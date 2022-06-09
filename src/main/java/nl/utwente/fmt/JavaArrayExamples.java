package nl.utwente.fmt;


class JavaArrayExamples {
    /*@
      context_everywhere a != null;
      context (\forall* int i ; 0 <= i && i < a.length ; Perm(a[i],write));
    @*/
    public void shift_drf(int a[]){
        for(int i=0;i<a.length;i++)
    /*@
      requires Perm(a[i],1\2);
      requires i==0 ==> Perm(a[i],1\2);
      requires i < a.length-1 ==> Perm(a[i+1],1\2);
      ensures  Perm(a[i],write);
    @*/
        {
            //@ ghost S1:if(i>0){ recv 0 < i ** i < a.length ** Perm(a[i],1\2) from S2,1; }
            S2:if (i < a.length-1) {
                a[i]=a[i+1];
                //@ send 0 <= i ** i < a.length - 1 ** Perm(a[i+1],1\2) to S1,1;
            }
        }
    }

    /*@
      context_everywhere ar!=null;
      context_everywhere (\forall* int k ; 0 <= k && k < ar.length ; Perm(ar[k],1));
      ensures (\forall int k ; 0 <= k && k < ar.length ; ar[k]==0 ) ;
    @*/
    public void zero_array(int ar[]){
        int i=0;
        int N=ar.length;
        //@ loop_invariant 0<= i && i<=N && N==ar.length ;
        //@ loop_invariant (\forall int k ; 0 <= k && k < i ; ar[k]==0 ) ;
        while(i<N){
            ar[i]=0;
            i++;
        }
    }

    /*@
        context_everywhere ar != null ** M>0 ** N > 0 ** M * N == ar.length;
        context   (\forall* int k ; 0 <= k && k < ar.length ; Perm(ar[k],write));
        ensures   (\forall  int k ; 0 <= k && k < ar.length ; ar[k]==0 ) ;
     */
    public void zero_array_nested(int ar[],int M,int N){
        for(int i=0;i<M;i++)
    /*@
      context (\forall* int k ; i*N <= k && k < (i+1)*N ; Perm(ar[k],write));
      ensures (\forall  int k ; i*N <= k && k < (i+1)*N ; ar[k]==0 ) ;
    @*/
        {
            for(int j=0;j<N;j++)
      /*@
		context 0 <= i && i < M;
        context Perm(ar[i*N+j],write);
        ensures  ar[i*N+j]==0;
      @*/
            {
                ar[i*N+j]=0;
            }
        }
    }

    /*@
      context_everywhere ar != null ** M>0 ** N > 0 ** M * N == ar.length;
      context (\forall* int k ; 0 <= k && k < ar.length ; Perm(ar[k],write));
      ensures (\forall  int k ; 0 <= k && k < ar.length ; ar[k]==0 ) ;
    @*/
    public void zero_array_smart_nested(int ar[],int M,int N) {
        for(int i=0;i<M;i++) {
            for(int j=0;j<N;j++)
      /*@
        context Perm(ar[i*N+j],write);
        ensures ar[i*N+j]==0;
      @*/
            {
                ar[i*N+j]=0;
            }
        }
    }

}

