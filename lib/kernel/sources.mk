# sources.mk - a template for the target overridden kernel library makefiles
# 
# Copyright (c) 2011-2013 Universidad Rey Juan Carlos
#                         Pekka Jääskeläinen / Tampere University of Technology
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

CLANGFLAGS = -emit-llvm

#Search the .cl,.c and .ll sources first from this (target specific) directory, then
#the one-up (generic) directory. This allows to override the generic implementation 
#simply by adding a similarly named file in the target specific directory
vpath %.cl @srcdir@:${SECONDARY_VPATH}:@srcdir@/..
vpath %.c @srcdir@:${SECONDARY_VPATH}:@srcdir@/..
vpath %.ll @srcdir@:${SECONDARY_VPATH}:@srcdir@/..
vpath %.h @top_srcdir@/include:@srcdir@:@srcdir@/..
vpath %.cc @srcdir@:@srcdir@/../vecmathlib/pocl:@srcdir@/..

LKERNEL_HDRS=templates.h image.h
# Nodist here because these files should be included
# to the distribution only once, from the root kernel
# makefile.
LKERNEL_SRCS_DEFAULT= \
	barrier.ll				\
	get_work_dim.c				\
	get_global_size.c			\
	get_global_id.c				\
	get_local_size.c			\
	get_local_id.c				\
	get_num_groups.c			\
	get_group_id.c				\
	get_global_offset.c			\
	as_type.cl				\
	atomics.cl				\
	acos.cl					\
	acosh.cl				\
	acospi.cl				\
	asin.cl					\
	asinh.cl				\
	asinpi.cl				\
	atan.cl					\
	atan2.cl				\
	atan2pi.cl				\
	atanh.cl				\
	atanpi.cl				\
	cbrt.cl					\
	ceil.cl					\
	convert_type.cl				\
	copysign.cl				\
	cos.cl					\
	cosh.cl					\
	cospi.cl				\
	erfc.cl					\
	erf.cl					\
	exp.cl					\
	exp2.cl					\
	exp10.cl				\
	expm1.cl				\
	fabs.cl					\
	fdim.cl					\
	floor.cl				\
	fma.cl					\
	fmax.cl					\
	fmin.cl					\
	fmod.cl					\
	fract.cl				\
	hypot.cl				\
	ilogb.cl				\
	ldexp.cl				\
	lgamma.cl				\
	log.cl					\
	log2.cl					\
	log10.cl				\
	log1p.cl				\
	logb.cl					\
	mad.cl					\
	maxmag.cl				\
	minmag.cl				\
	nan.cl					\
	nextafter.cl				\
	pow.cl					\
	pown.cl					\
	powr.cl					\
	remainder.cl				\
	rint.cl					\
	rootn.cl				\
	round.cl				\
	rsqrt.cl				\
	sin.cl					\
	sincos.cl				\
	sinh.cl					\
	sinpi.cl				\
	sqrt.cl					\
	tan.cl					\
	tanh.cl					\
	tanpi.cl				\
	tgamma.cl				\
	trunc.cl				\
	divide.cl				\
	recip.cl				\
	abs.cl					\
	abs_diff.cl				\
	add_sat.cl				\
	hadd.cl					\
	rhadd.cl				\
	clamp.cl				\
	clz.cl					\
	mad_hi.cl				\
	mad_sat.cl				\
	max.cl					\
	min.cl					\
	mul_hi.cl				\
	rotate.cl				\
	sub_sat.cl				\
	upsample.cl				\
	popcount.cl				\
	mad24.cl				\
	mul24.cl				\
	degrees.cl				\
	mix.cl					\
	radians.cl				\
	step.cl					\
	smoothstep.cl				\
	sign.cl					\
	cross.cl				\
	dot.cl					\
	distance.cl				\
	length.cl				\
	normalize.cl				\
	fast_distance.cl			\
	fast_length.cl				\
	fast_normalize.cl			\
	isequal.cl				\
	isnotequal.cl				\
	isgreater.cl				\
	isgreaterequal.cl			\
	isless.cl				\
	islessequal.cl				\
	islessgreater.cl			\
	isfinite.cl				\
	isinf.cl				\
	isnan.cl				\
	isnormal.cl				\
	isordered.cl				\
	isunordered.cl				\
	signbit.cl				\
	any.cl					\
	all.cl					\
	bitselect.cl				\
	select.cl				\
	vload.cl				\
	vstore.cl				\
	vload_half.cl				\
	vstore_half.cl				\
	async_work_group_copy.cl		\
	wait_group_events.cl			\
	read_image.cl				\
	write_image.cl				\
	get_image_width.cl			\
	get_image_height.cl     

# The standard list of kernel sources can be modified with
# EXCLUDE_SRC_FILES, which removes files from the standard list and
# LKERNEL_EXTRA_SRCS, which adds extra files to the source list.
LKERNEL_SRCS = $(filter-out ${EXCLUDE_SRC_FILES}, ${LKERNEL_SRCS_DEFAULT} ) \
	${LKERNEL_EXTRA_SRCS}

OBJ_L=$(LKERNEL_SRCS:.cl=.bc)
OBJ_C=$(OBJ_L:.ll=.bc)
OBJ_CC=$(OBJ_C:.cc=.cc.bc)
OBJ=$(OBJ_CC:.c=.bc)

OBJ:LKERNEL_SRCS

#libkernel_SRCS = $LIBKERNEL_SOURCES

#rules to compile the different kernel library source file types into LLVM bitcode
%.bc: %.c @top_builddir@/include/${TARGET_DIR}/types.h
	@CLANG@ -emit-llvm -c -target ${KERNEL_TARGET} -o $@ -x c $< -include ../../../include/${TARGET_DIR}/types.h
%.bc: %.cl @top_builddir@/include/${TARGET_DIR}/types.h @top_srcdir@/include/_kernel.h
	@CLANG@ -emit-llvm -c -target ${KERNEL_TARGET} -o $@ -x cl $< -include ../../../include/${TARGET_DIR}/types.h \
		-include ${abs_top_srcdir}/include/_kernel.h

# -isystem /usr/include/c++/4.4 -isystem /usr/include/c++/4.4/x86_64-linux-gnu -std=c++0x
%.cc.bc: %.cc 
	@CLANGPP@ -std=gnu++11 -emit-llvm -c -target ${KERNEL_TARGET} \
	-include ../../../include/${TARGET_DIR}/types.h -o $@ $< 

CLEANFILES = kernel-${KERNEL_TARGET}.bc ${OBJ}

kernel-${KERNEL_TARGET}.bc: ${OBJ}
	llvm-link -o $@ $^

# We need an explicitly rule to overwrite automake guess about LEX file :-(
barrier.bc: barrier.ll
	@LLVM_AS@ -o $@ $<
