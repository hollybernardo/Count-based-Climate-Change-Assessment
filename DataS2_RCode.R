#read in data for full climate analysis
data <- read.csv("DataS2.csv")

#subset data to interact threats; run remainder of code using one subset at a time
#For No/Low scenario
#data <- subset(data, woody!="high")
#data <-subset(data, deer!="high")
#For Low/High Scenario
#data <- subset(data, woody!="none") 
#data <- subset(data, deer!="none")


#AIC chosen model
HayhoeLM <- glm(avgr.t.~WSprcp + WINtemp + SUtemp +0, data=data)
#extraxt correlation coefficients
betaprcp <- HayhoeLM$coefficients[1]  
betawintertemp <- HayhoeLM$coefficients[2]  
betasummertemp <- HayhoeLM$coefficients[3] 

#read in historic climate data files; these data were exracted from ArcGIS using WorldClim Current Data (see text)
WTavgHistoric <- read.csv("TAVGwinterWORLDCLIM.csv")
STavgHistoric <- read.csv("TAVGsummerWORLDCLIM.csv")
PrsumHistoric <- read.csv("precWSWORLDCLIM.csv")
WinTAVG <- c(rep(WTavgHistoric$VALUE,WTavgHistoric$COUNT))
SumTAVG <- c(rep(STavgHistoric$VALUE,STavgHistoric$COUNT))
WinSpPREC <- c(rep(PrsumHistoric$VALUE,PrsumHistoric$COUNT))

#historic distributions of climate data
WSPT.meanH=mean(WinSpPREC)
WSPT.sd=sd(WinSpPREC)
WTA.meanH=mean(WinTAVG)
WTA.sd=sd(WinTAVG)
STA.meanH=mean(SumTAVG)
STA.sd=sd(SumTAVG)
#future distributions for climate change, sd as historic; based on Hayhoe et. al. (2010) predictions (see text)
WSPT.meanF <- WSPT.meanH + WSPT.meanH*.1 
WTA.meanF <- WTA.meanH+2 
STA.meanF <- STA.meanH+1

#projeciton model#

#output files
Nh <-matrix(NA,nrow=50,ncol=1000)
Nf <- matrix(NA,nrow=50,ncol=1000)
ExtH<-rep(NA,1000)
ExtF<-rep(NA,1000)
#carrying capacity
K=20868

#loop; 1000 replicate 50-year projections
for (t in 1:1000)
{
#pick climate values from historic distributions
WSPTh=rnorm(50, WSPT.meanH, WSPT.sd)
WTAh=rnorm(50, WTA.meanH, WTA.sd)
STAh=rnorm(50, STA.meanH, STA.sd)
#pick climate values from future distributions
WSPTf=rnorm(50, WSPT.meanF, WSPT.sd)
WTAf=rnorm(50, WTA.meanF, WTA.sd)
STAf=c(rnorm(35, STA.meanH, STA.sd), rnorm(15,STA.meanF,STA.sd))

#make string of LRR values; H = historic / F = Future
rtH <- betaprcp*WSPTh + betawintertemp*WTAh + betasummertemp*STAh
rtF <- betaprcp*WSPTf + betawintertemp*WTAf + betasummertemp*STAf

#Sensitivity analysis; run remainder of code using one new rtF string at a time
#setting WSprec to historic dist
#rtF <- betaprcp*WSPTh + betawintertemp*WTAf + betasummertemp*STAf
#setting WinTemp to historic dist
#rtF <- betaprcp*WSPTf + betawintertemp*WTAh + betasummertemp*STAf
#setting SumTemp to historic dist
#rtF <- betaprcp*WSPTf + betawintertemp*WTAf + betasummertemp*STAh

#startng population size
n0h=343
n0f=343

#50-year projection
for (n in 1:50)
{
n0h <- n0h*exp(rtH[n]) #computes N(t+1) = Nt*exp(LRR); eq(2) in text
if (n0h>=K) {
  n0h=K #to bring the total down to the carrying capacity if it exceeds carrying capacity
} else {
  n0h=n0h
}
if (n0h<1) {
  n0h=0 #to set a population as zero if it drops below 1 individual
} else {
  n0h=n0h
}
Nh[n,t]=n0h

n0f <- n0f*exp(rtF[n]) #computes N(t+1) = Nt*exp(LRR); eq(2) in text
if (n0f>=K) {
  n0f=K
} else {
  n0f=n0f
}
if (n0f<1) {
  n0f=0
} else {
  n0f=n0f
}
Nf[n,t]=n0f
} #end of 50 year

#capture extinctions
if (min(Nh[,t])<=10){ #quasi-extinction threshold = 10 Ind
  ExtH[t]=1
} else {
  ExtH[t]=0
}
if (min(Nf[,t])<=10){ 
  ExtF[t]=1
} else {
  ExtF[t]=0
}
} #end of 1,000 reps

#calulate the probability of extinction
probextH=sum(ExtH)/1000 
probextF=sum(ExtF)/1000 

#extract results; each column is one replicate 50-year projection
write.csv(Nh, "HayhoeHistoricCC.csv")
write.csv(Nf, "HayHoeFutureCC.csv")