#Read in data
datathreats <- read.csv("DataS1.csv")

#subsetting data into scenarios
#no/low both scenario
NL=subset(datathreats, datathreats$woody!="high")
#low deer + low/high woody scenario
LH=subset(datathreats, datathreats$woody!="none" & datathreats$deer=="low")

#projection Model#

#distribution stats
NL.mean=mean(NL$r.t.) 
NL.sd=sqrt(var(NL$r.t.)) 
LH.mean=mean(LH$r.t.) 
LH.sd=sqrt(var(LH$r.t.)) 

#output files
NNL <-matrix(NA,nrow=50,ncol=1000)
NLH <-matrix(NA,nrow=50,ncol=1000)
ExtNL<-rep(NA,1000)
ExtLH<-rep(NA,1000)

#carrying capacity
K = 20868

#loop; 1000 replicate 50-year projections
for (t in 1:1000) 
{
#pick values from each scenario's distribution
rtNL=rnorm(50, NL.mean, NL.sd)
rtLH=rnorm(50, LH.mean, LH.sd)
  
#starting population size 
n0NL=343
n0LH=343

#loop; 50-year projection
  for (n in 1:50) 
  {
    n0NL <- n0NL*exp(rtNL[1]) #computes N(t+1) = Nt*exp(LRR); eq(2) in text
    if (n0NL>=K) {
      n0NL=K #to bring the total down to  carrying capacity if total exceeds carrying capacity
    } else {
      n0NL=n0NL
    }
    if (n0NL<1) {
      n0NL=0 #to set a population as zero if it drops below 1 individual
    } else {
      n0NL=n0NL
    }
    NNL[n,t]=n0NL
       n0LH <- n0LH*exp(rtLH[n]) #computes N(t+1) = Nt*exp(LRR); eq(2) in text
    if (n0LH>=K) {
      n0LH=K 
    } else {
      n0LH=n0LH
    }
    if (n0LH<1) {
      n0LH=0 
    } else {
      n0LH=n0LH
    }
    NLH[n,t]=n0LH
  } #end of 50 year projection
  
  #capture extinctions
  if (min(NNL[,t])<=10){ #quasi-extinction threshold  = 10 Ind
    ExtNL[t]=1
  } else {
    ExtNL[t]=0
  }
  if (min(NLH[,t])<=10){
    ExtLH[t]=1
  } else {
    ExtLH[t]=0
  }
} #end of 1,000 replicates

#calculate the probability of extinction
probext.NL=sum(ExtNL)/1000 
probext.LH=sum(ExtLH)/1000

#extract results; each column is one replicate 50-year projection
write.csv(NNL,"nlboth__Graphing.csv")
write.csv(NLH,"lD.lhW_Graphing.csv")