// Class definition for parallel regions, a group of BasicBlocks that
// each kernel should run in parallel.
// 
// Copyright (c) 2011 Universidad Rey Juan Carlos
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/BasicBlock.h"
#include "llvm/Support/CFG.h"
#include "llvm/Transforms/Utils/ValueMapper.h"
#include <vector>

namespace pocl {
  
  class ParallelRegion : public std::vector<llvm::BasicBlock *> {
    
  public:    
    ParallelRegion *replicate(llvm::ValueToValueMapTy &map,
                              const llvm::Twine &suffix);
    void remap(llvm::ValueToValueMapTy &map);
    void purge();
    void chainAfter(ParallelRegion *region);
    void insertPrologue(unsigned x, unsigned y, unsigned z);
    void dump();

    static ParallelRegion *Create(llvm::SmallPtrSetIterator<llvm::BasicBlock *> entry,
                                  llvm::SmallPtrSetIterator<llvm::BasicBlock *> exit);
    
  private:
    bool Verify();
  };
    
}
                              
