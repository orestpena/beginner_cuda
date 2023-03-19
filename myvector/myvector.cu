#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

// this function is run in the gpu
__global__ void vectorAdd(int* a, int* b, int* c)
{
    //we are creating a list of threads and the .x will indicate the vecotr where we are
    int i = threadIdx.x;
    c[i] = a[i] + b[i];

    return;
}

int main()
{
    // larger values
    int a[] = { 1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3,1,2,3, };
    int b[] = { 4,5,6,4,5,6,4,5,6,4,5,6,4,5,6,4,5,6,4,5,6,4,5,6, };
    // original values
    //int a[] = { 1,2,3, };
    //int b[] = { 4,5,6 };
    int c[sizeof(a) / sizeof(int)] = { 0 };

    //for (int i = 0; i < sizeof(c) / sizeof(int); i++)
    //{
    //    c[i] = a[i] + b[i];
    //}

    // create pointers into the gpu
    int* cudaA = 0;
    int* cudaB = 0;
    int* cudaC = 0;
    
    // allocate memory in the gpu
    cudaMalloc(&cudaA, sizeof(a));
    cudaMalloc(&cudaB, sizeof(b));
    cudaMalloc(&cudaC, sizeof(c));

    // copy the vectors into the gpu
    cudaMemcpy(cudaA, a, sizeof(a), cudaMemcpyHostToDevice);
    cudaMemcpy(cudaB, b, sizeof(b), cudaMemcpyHostToDevice);
    //cudaMemcpy(cudaC, c, sizeof(a), cudaMemcpyHostToDevice);
    
    // this needs to be instantiated
    //vectorAdd<<<GRID_SIZE, BLOCK_SIZE
    // GRID_SIZE is the number of blocks that it has
    // per the amount of blocks it says how many threads exist per block
    // block size is the number of vectors or threads
    
    //explanation
    //run this function vectorAdd (<<< in a cuda kernel) in a grid that has 1 block, with the block have this many threads (>>> and call it with these parameters)
    vectorAdd <<< 1, sizeof(a) / sizeof(int) >>> (cudaA, cudaB, cudaC);

    cudaMemcpy(c, cudaC, sizeof(c), cudaMemcpyDeviceToHost);

    return;
}

//
// This is code just running on cpu
//
//    int a[] = { 1,2,3 };
//    int b[] = { 4,5,6 };
//    int c[sizeof(a) / sizeof(int)] = { 0 };
//    
//    for (int i = 0; i < sizeof(c) / sizeof(int); i++)
//    {
//        c[i] = a[i] + b[i];
//    }
//
//    return;
