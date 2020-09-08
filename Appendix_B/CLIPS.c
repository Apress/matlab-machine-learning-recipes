//
//  CLIPS.c
//  

#include "CLIPS.h"
#include "mex.h"

// The CLIPS headers
#include "CLIPSHeaders/setup.h"
#include "CLIPSHeaders/clips.h"

void cbkFunction();

int results_flag = 0;

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    // Check the function arguments
    if( nrhs != 1 )
    {
        mexErrMsgTxt("One input required.");
    }
    
    if( nlhs > 1 )
    {
        mexErrMsgTxt("Too many output arguments.");
    }
    
    // Initialize CLIPS
    InitializeEnvironment();
   
    // Check to make sure the results function is available
    char* fun = strdup("cbkFunction");
    if (DefineFunction(fun,'v',PTIF cbkFunction,fun) == 0)
    {
        mexErrMsgTxt("Couldn't register cbkFunction with CLIPS");
        return;
    }
    
    // Load the rules
    char file[] = "Rules.CLP";
    
    if( !Load(file) )
    {
        mexErrMsgTxt("Couldn't load the CLIPS rules file");
        return;
    }
    
    // Check the facts
    
    char* clips_facts;
    
    if ( mxIsChar(prhs[0]) != 1)
    {
        mexErrMsgIdAndTxt( "MATLAB:CLIPS:inputNotString",
              "Input must be a string.");
    }

    clips_facts = mxArrayToString(prhs[0]);
    
    if (LoadFactsFromString(clips_facts, -1) == 0)
    {
        mexErrMsgTxt("Error occured loading facts");
        exit(-1);
        mxFree(clips_facts);
        return;
    }
    
    // Running the rules
    
    results_flag = 0;
    
    Run(-1);
    
    // Report the results
    
    char* results_string;
    results_string = mxCalloc(14, sizeof(char));
    if( !results_flag )
    {
        strcpy(results_string,"Wheel working");
    }
    else
    {
        strcpy(results_string,"Wheel failed");
    }
    
    mxFree(clips_facts);
    plhs[0] = mxCreateString(results_string);
}

void cbkFunction()
{
    results_flag = 1;
}
