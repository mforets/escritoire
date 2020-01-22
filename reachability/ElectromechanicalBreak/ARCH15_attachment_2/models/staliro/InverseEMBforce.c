/* Program created by Mathematica     23.4.2007     16:18 */

/* Inverses EMB System (beim Bremsen) */

#define S_FUNCTION_NAME InverseEMBforce
#define S_FUNCTION_LEVEL 2 

#include  "simstruc.h"   
#include  "math.h"       

/* Predefines */
#define sign(x) ((x>0) ? 1 : (x==0) ? 0 : -1)

/* Parameters */
#define R(S) ssGetSFcnParam(S, 0)  /* Widerstand R [Ohm]: */
#define L(S) ssGetSFcnParam(S, 1)  /* Induktivitaet L [H]: */
#define K(S) ssGetSFcnParam(S, 2)  /* Motorkonstante K [Vs]: */
#define J(S) ssGetSFcnParam(S, 3)  /* Traegheitsmoment J [kgm^2]: */
#define dvrot(S) ssGetSFcnParam(S, 4)  /* Viskose Reibung dvrot [Nms/rad]: */
#define m(S) ssGetSFcnParam(S, 5)  /* Masse m [kg]: */
#define dvtrans(S) ssGetSFcnParam(S, 6)  /* Viskose Reibung dvtrans [Ns/m]: */
#define cgear(S) ssGetSFcnParam(S, 7)  /* Steifigkeit Getriebe cgear [N/m]: */
#define i(S) ssGetSFcnParam(S, 8)  /* Uebersetzung i [-]: */
#define cbreak(S) ssGetSFcnParam(S, 9)  /* Steifigkeit Bremse cbreak [N/m]: */
#define x0(S) ssGetSFcnParam(S, 10)  /* Position x0 [m]: */
#define xic(S)   ssGetSFcnParam(S, 11)  /* initial values */

/*==============*   
* misc defines *   
*==============*/   
#if !defined(TRUE)   
#define TRUE  1   
#endif    
#if !defined(FALSE)   
#define FALSE 0   
#endif    

    
/*=========================*   
 * Local Utility Functions *     
 *=========================*/   

   
/* Function: IsRealVect   
 * Abstract: Verify that the mxArray is a real vector.*/
   
static boolean_T IsRealVect(const mxArray *m)   
{
     if (mxIsNumeric(m) &&
         mxIsDouble(m) &&
         !mxIsLogical(m) &&
         !mxIsComplex(m) &&
         !mxIsSparse(m) &&
         !mxIsEmpty(m) &&
         mxGetNumberOfDimensions(m) == 2 &&
         (mxGetM(m) == 1 || mxGetN(m) == 1))
        {

           real_T *data = mxGetPr(m);
           int_T  numEl = mxGetNumberOfElements(m);
           int_T  i;

           for (i = 0; i < numEl; i++) {
               if (!mxIsFinite(data[i])) {
                   return(FALSE);
               }
           }
               
           return(TRUE);
       } else {
           return(FALSE);
       }
    }    
/* end IsRealVect */ 


#if defined(MATLAB_MEX_FILE)                        
#define MDL_CHECK_PARAMETERS                      
  static void mdlCheckParameters(SimStruct *S)       
  {
     if (!mxIsDouble(R(S)) || mxGetNumberOfElements(R(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"R\" value.");
        return;}
     if (!mxIsDouble(L(S)) || mxGetNumberOfElements(L(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"L\" value.");
        return;}
     if (!mxIsDouble(K(S)) || mxGetNumberOfElements(K(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"K\" value.");
        return;}
     if (!mxIsDouble(J(S)) || mxGetNumberOfElements(J(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"J\" value.");
        return;}
     if (!mxIsDouble(dvrot(S)) || mxGetNumberOfElements(dvrot(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"dvrot\" value.");
        return;}
     if (!mxIsDouble(m(S)) || mxGetNumberOfElements(m(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"m\" value.");
        return;}
     if (!mxIsDouble(dvtrans(S)) || mxGetNumberOfElements(dvtrans(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"dvtrans\" value.");
        return;}
     if (!mxIsDouble(cgear(S)) || mxGetNumberOfElements(cgear(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"cgear\" value.");
        return;}
     if (!mxIsDouble(i(S)) || mxGetNumberOfElements(i(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"i\" value.");
        return;}
     if (!mxIsDouble(cbreak(S)) || mxGetNumberOfElements(cbreak(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"cbreak\" value.");
        return;}
     if (!mxIsDouble(x0(S)) || mxGetNumberOfElements(x0(S)) != 1 ) {
         ssSetErrorStatus(S,"Parameter has to be a "
                           " scalar \"x0\" value.");
        return;}
     if (!IsRealVect(xic(S)) || mxGetNumberOfElements(xic(S)) != 1) {
         ssSetErrorStatus(S,"Initial values have to be a "
                          " real \"xic\" vector with 1 elements.");
        return;}
  } 
#endif


/*====================*                        
 * S-function methods *                        
 *====================*/
                        
/* No Comment */
                        
static void mdlInitializeSizes(SimStruct *S)                        
{
 ssSetNumSFcnParams(S, 12); /*Number of parameters; see above */


 #if defined(MATLAB_MEX_FILE)                        
    if (ssGetNumSFcnParams(S) == ssGetSFcnParamsCount(S))                        
      {                        
        mdlCheckParameters(S);                        
        if (ssGetErrorStatus(S) != NULL)                         
         {return;}                        
      }                        
    else                        
      {return; /* Parameter mismatch will be reported */}                        
 #endif
                        
    ssSetNumContStates(S, 1);                        
    ssSetNumDiscStates(S, 0);                                         

    if (!ssSetNumInputPorts(S, 6)) return;                    
    ssSetInputPortWidth(S, 0, 1);
    ssSetInputPortWidth(S, 1, 1);
    ssSetInputPortWidth(S, 2, 1);
    ssSetInputPortWidth(S, 3, 1);
    ssSetInputPortWidth(S, 4, 1);
    ssSetInputPortWidth(S, 5, 1);
    ssSetInputPortDirectFeedThrough(S, 0, 0);   /* Nondirect feedtrough */
    ssSetInputPortDirectFeedThrough(S, 1, 0);   /* Nondirect feedtrough */
    ssSetInputPortDirectFeedThrough(S, 2, 0);   /* Nondirect feedtrough */
    ssSetInputPortDirectFeedThrough(S, 3, 0);   /* Nondirect feedtrough */
    ssSetInputPortDirectFeedThrough(S, 4, 0);   /* Nondirect feedtrough */
    ssSetInputPortDirectFeedThrough(S, 5, 0);   /* Nondirect feedtrough */

    if (!ssSetNumOutputPorts(S, 1)) return;
    ssSetOutputPortWidth(S, 0, 1);

    ssSetNumSampleTimes(S, 1);        /* One sample time */                       
    ssSetNumRWork(S, 1);              /* Help variables (real) */                       
    ssSetNumIWork(S, 0);                       
    ssSetNumPWork(S, 0);                       
    ssSetNumModes(S, 0);                       
    ssSetNumNonsampledZCs(S, 0);      /* Two for each Limit */          

    ssSetOptions(S, SS_OPTION_EXCEPTION_FREE_CODE);

}                            

static void mdlInitializeSampleTimes(SimStruct *S)                       
{                       
  ssSetSampleTime(S, 0, CONTINUOUS_SAMPLE_TIME);                       
  ssSetOffsetTime(S, 0, 0.0);                       
}                 




#undef MDL_GET_TIME_OF_NEXT_VAR_HIT
#if defined(MDL_GET_TIME_OF_NEXT_VAR_HIT) && (defined(MATLAB_MEX_FILE) || defined(NRT))  
  /*Function:mdlGetTimeOfNextVarHit ===================================================  
   *Abstract:  
   *This function is called to get the time of the next variable sample  
   *time hit. This function is called once for every major integration time   
   *step. It must return time of next hit by using ssSetTNext. The time of  
   *the next hit must be greater then ssGetT(S).  
   *  
   *Note, the time of next hit can be a function of the input signals (S).  
   */  

static void mdlGetTimeOfNextVarHit(SimStruct *S)  
{  
   ssGetTNext(S, <timeOfNextHit>);

/*Put all your commands here 
                 use C-commands to get the appropriate textual format.*/

}                                   
#endif /*MDL_GET_TIME_OF_NEXT_VAR_HIT*/




#undef MDL_ZERO_CROSSINGS
#if defined(MDL_ZERO_CROSSINGS) && (defined(MATLAB_MEX_FILE) || defined(NRT))   
  /*Function: mdlZeroCrossings =============================================   
   *Abstract:   
   *If your S-function has registered CONTINUOUS_SAMPLE_TIME and there   
   *signals entering the S_Function or internally generated signals   
   *which have discontinuities, you can use this routine to locate the   
   *discontinuities. When called, this routine must update the   
   *ssGetNonSampleZCs(S) vector.   
   */   

static void mdlZeroCrossings(SimStruct *S)   
{

   /*Your input was 0 nonsampled zero crossings*/

/*Put all your commands here 
                 use C-commands to get the appropriate textual format.*/

}                                   
#endif /*MDL_ZERO_CROSSINGS*/




static void mdlOutputs(SimStruct *S, int_T tid)   
  /*Function: mdlOutputs =================   
   *Abstract:    
   *In this block, you compute the outputs of your S-function block.   
   *Generally outputs are placed in the output vector(s),   
   *ssGetOutputPortSignal.   
   */   
{   
  /*States*/
   real_T  *X      = ssGetContStates(S);

  /* Assign outputs */
   real_T  *y1  = ssGetOutputPortRealSignal(S,0);

  /*Parameters in output equations*/
   real_T  R = *mxGetPr(R(S));
   real_T  L = *mxGetPr(L(S));
   real_T  K = *mxGetPr(K(S));
   real_T  J = *mxGetPr(J(S));
   real_T  dvrot = *mxGetPr(dvrot(S));
   real_T  m = *mxGetPr(m(S));
   real_T  dvtrans = *mxGetPr(dvtrans(S));
   real_T  cgear = *mxGetPr(cgear(S));
   real_T  i = *mxGetPr(i(S));
   real_T  cbreak = *mxGetPr(cbreak(S));
   real_T  x0 = *mxGetPr(x0(S));

  /*Inputs u in equations*/
  /*None*/

  /*Helpvariables*/                                                   
   real_T   *hevar = ssGetRWork(S);

  /*No algebraic equations*/

  /*Equations*/
   /*Put additonal C-Code here!*/

   y1[0] = hevar[0];
} /* end mdlOutputs */




#undef MDL_UPDATE
#if defined(MDL_UPDATE)   
  /*Function:mdlUpdate ====================================================   
   *Abstract:   
   *This function is called once for every majorintegration time step.     
   *Discrete states are typically updated here, but this function is useful   
   *for performing any tasks that should only take place one per    
   *integration step.   
   */    

static void mdlUpdate(SimStruct *S, int_T tid)   
{
/*Put all your commands here 
                 use C-commands to get the appropriate textual format.*/

}                                   
#endif /*MDL_UPDATE*/




#define MDL_DERIVATIVES   /*Change to #undef to remove function*/    
#if defined(MDL_DERIVATIVES)    
  /*Function: mdlDerivatives ===================    
   *Abstract:     
   *xdot = A x + B u    
  */    
static void mdlDerivatives(SimStruct *S)    
{    
  /*States*/    
   real_T  *dX     = ssGetdX(S);    
   real_T  *X      = ssGetContStates(S);

  /*Parameters in differential equations*/
   real_T  R = *mxGetPr(R(S));
   real_T  L = *mxGetPr(L(S));
   real_T  K = *mxGetPr(K(S));
   real_T  J = *mxGetPr(J(S));
   real_T  dvrot = *mxGetPr(dvrot(S));
   real_T  m = *mxGetPr(m(S));
   real_T  dvtrans = *mxGetPr(dvtrans(S));
   real_T  cgear = *mxGetPr(cgear(S));
   real_T  i = *mxGetPr(i(S));
   real_T  cbreak = *mxGetPr(cbreak(S));
   real_T  x0 = *mxGetPr(x0(S));

  /*Inputs u in equations*/
   InputRealPtrsType  u1   = ssGetInputPortRealSignalPtrs(S,0);
   InputRealPtrsType  u2   = ssGetInputPortRealSignalPtrs(S,1);
   InputRealPtrsType  u3   = ssGetInputPortRealSignalPtrs(S,2);
   InputRealPtrsType  u4   = ssGetInputPortRealSignalPtrs(S,3);
   InputRealPtrsType  u5   = ssGetInputPortRealSignalPtrs(S,4);
   InputRealPtrsType  u6   = ssGetInputPortRealSignalPtrs(S,5);

  /*Helpvariables*/                                                   
   real_T   *hevar = ssGetRWork(S);

  /*Additional algebraic equations*/
   hevar[0]  =  (cbreak*(cgear*(-(R*x0) + R*(*u1[0]) + L*(*u2[0])) + i*(pow(K,2)*(*u2[0]) + dvrot*R*(*u2[0]) + dvrot*L*(*u3[0]) + J*R*(*u3[0]) + J*L*(*u4[0]))) + cgear*(dvtrans*R*(*u2[0]) + dvtrans*L*(*u3[0]) + m*R*(*u3[0]) + L*m*(*u4[0]) + pow(i,2)*(pow(K,2)*(*u2[0]) + dvrot*R*(*u2[0]) + dvrot*L*(*u3[0]) + J*R*(*u3[0]) + J*L*(*u4[0]))) + i*(dvtrans*(pow(K,2)*(*u3[0]) + dvrot*R*(*u3[0]) + dvrot*L*(*u4[0]) + J*R*(*u4[0]) + J*L*(*u5[0])) + m*(pow(K,2)*(*u4[0]) + dvrot*R*(*u4[0]) + dvrot*L*(*u5[0]) + J*R*(*u5[0]) + J*L*(*u6[0]))))/(cgear*i*K);

  /*Equations*/
   /*Put additonal C-Code here!*/

   dX[0] = 0;
}
#endif /* MDL_DERIVATIVES */


static void mdlTerminate(SimStruct *S)                        
{                        
}                        


/*======================================================*                        
 * See sfuntmpl.doc for the optional S-function methods *                        
 *======================================================*/                        


/*=============================*                        
 * Required S-function trailer *                        
 *=============================*/                        


#ifdef  MATLAB_MEX_FILE                        
#include "simulink.c"                        
#else                        
#include "cg_sfun.h"                        
#endif

