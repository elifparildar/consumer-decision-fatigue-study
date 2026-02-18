* Encoding: UTF-8.
#gruplara ayırdık her conditionı
DATASET ACTIVATE DataSet2.
IF  (NOT MISSING(DecisionFatigue_A_1)) condition=1.
EXECUTE.

IF  (NOT MISSING(DecisionFatigue_B_1)) condition=2.
EXECUTE.

IF  (NOT MISSING(DecisionFatigue_C_1)) condition=3.
EXECUTE.

#missing olanları attık 
USE ALL.
COMPUTE filter_$=(NOT MISSING(condition)).
VARIABLE LABELS filter_$ 'NOT MISSING(condition) (FILTER)'.
VALUE LABELS filter_$ 0 'Not Selected' 1 'Selected'.
FORMATS filter_$ (f1.0).
FILTER BY filter_$.
EXECUTE.

FILTER OFF.
USE ALL.
SELECT IF (NOT MISSING(condition)).
EXECUTE.

#abc olcak şekilde sıraladık 
SORT CASES BY condition(A).

# attenion checki geçemeyenleri attık 
FILTER OFF.
USE ALL.
SELECT IF ((condition = 1 AND Attention_A = 1)OR(condition = 2 AND Attention_B = 1)OR(condition = 3 
    AND Attention_C = 1)).
EXECUTE.


decision fatigue için mean hesapladık 

COMPUTE Fatigue_A=MEAN(DecisionFatigue_A_1,DecisionFatigue_A_2,DecisionFatigue_A_4).
EXECUTE.

COMPUTE Fatigue_B=MEAN(DecisionFatigue_B_1,DecisionFatigue_B_2,DecisionFatigue_B_4).
EXECUTE.

COMPUTE Fatigue_C=MEAN(DecisionFatigue_C_1,DecisionFatigue_C_2,DecisionFatigue_C_4).
EXECUTE.

COMPUTE Fatigue_score=MEAN(Fatigue_A, Fatigue_B, Fatigue_C).
EXECUTE.

## satisfaction için mena hesapladık 

COMPUTE Satisfaction_A=MEAN(DecisionSatis_A_1,DecisionSatis_A_2,DecisionSatis_A_3).
EXECUTE.

COMPUTE Satisfaction_B=MEAN(DecisionSatis_B_1,DecisionSatis_B_2,DecisionSatis_B_3).
EXECUTE.

COMPUTE Satisfaction_C=MEAN(DecisionSatis_C_1,DecisionSatis_C_2,DecisionSatis_C_3).
EXECUTE.

COMPUTE Satisfaction_score=MEAN(Satisfaction_A,Satisfaction_B,Satisfaction_C).
EXECUTE.

intention mean hesapladık 

COMPUTE Intention_A=MEAN(PurchaseIntention_A_1,PurchaseIntention_A_2,PurchaseIntention_A_3).
EXECUTE.

COMPUTE Intention_B=MEAN(PurchaseIntention_B_1,PurchaseIntention_B_2,PurchaseIntention_B_3).
EXECUTE.

COMPUTE Intention_C=MEAN(PurchaseIntention_C_1,PurchaseIntention_C_2,PurchaseIntention_C_3).
EXECUTE.

COMPUTE Intention_score=MEAN(Intention_A, Intention_B, Intention_C).
EXECUTE.

decision fatigue reliability 



RELIABILITY
  /VARIABLES=DecisionFatigue_A_1 DecisionFatigue_A_2 DecisionFatigue_A_4
  /SCALE('Decision Fatigue (A)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=DecisionFatigue_B_1 DecisionFatigue_B_2 DecisionFatigue_B_4
  /SCALE('Decision Fatigue (B)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=DecisionFatigue_C_1 DecisionFatigue_C_2 DecisionFatigue_C_4
  /SCALE('Decision Fatigue (C)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

satis için reliability

RELIABILITY
  /VARIABLES=DecisionSatis_A_1 DecisionSatis_A_2 DecisionSatis_A_3
  /SCALE('Decision Satisfaction (A)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=DecisionSatis_B_1 DecisionSatis_B_2 DecisionSatis_B_3
  /SCALE('Decision Satisfaction (B)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=DecisionSatis_C_1 DecisionSatis_C_2 DecisionSatis_C_3
  /SCALE('Decision Satisfaction (C)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

purhcase intention reliability

RELIABILITY
  /VARIABLES=PurchaseIntention_A_1 PurchaseIntention_A_2 PurchaseIntention_A_3
  /SCALE('Purchase Intention (A)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=PurchaseIntention_B_1 PurchaseIntention_B_2 PurchaseIntention_B_3
  /SCALE('Purchase Intention (B)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

RELIABILITY
  /VARIABLES=PurchaseIntention_C_1 PurchaseIntention_C_2 PurchaseIntention_C_3
  /SCALE('Purchase Intention (C)') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE SCALE
  /SUMMARY=TOTAL.

frequency 

DATASET ACTIVATE DataSet1.
FREQUENCIES VARIABLES=condition
  /ORDER=ANALYSIS.

timingi tek columnda topladık 

COMPUTE Decision_Time=MAX(Timing_A_Page_Submit,Timing_B_Page_Submit,Timing_C_Page_Submit).
EXECUTE.

descriptivese baktık 

EXAMINE VARIABLES=Fatigue_score Satisfaction_score Intention_score Decision_Time BY condition
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

## MANOVA

GLM Fatigue_score Satisfaction_score Intention_score BY condition
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /PRINT=DESCRIPTIVE ETASQ HOMOGENEITY
  /CRITERIA=ALPHA(.05)
  /DESIGN= condition.

ONEWAY Fatigue_score BY condition
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /CRITERIA=CILEVEL(0.95)
  /POSTHOC=GH ALPHA(0.05).

ONEWAY Satisfaction_score BY condition
  /STATISTICS DESCRIPTIVES 
  /MISSING ANALYSIS
  /CRITERIA=CILEVEL(0.95)
  /POSTHOC=TUKEY ALPHA(0.05).
