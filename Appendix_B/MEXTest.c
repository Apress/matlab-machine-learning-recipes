//
//  MEXTest.c
//  


#include "MEXTest.h"
#include "mex.h"


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    // Check the arguments
    if( nrhs != 2 )
    {
        mexErrMsgTxt("Two inputs required.");
    }
    
    if( nlhs != 1 )
    {
        mexErrMsgTxt("One output required.");
    }
 }
