
use Value.dta


* The control treatment for corner solutions is only analyzed in the end. We drop it for the main analysis:
keep if maecontrol==0

******************************************************************************************
* Footnote 8: Frequency of preferred variant choices:
tab varianta if type==0 & situation!=5 & situation!=10
tab variantp if type==1 & situation!=5 & situation!=10
dis 1-(41/(69*2*10))
* 97.03% of subjects chose their preferred project.

******************************************************************************************
* For simplicity, we now drop agents from the data set:
drop if type==0

******************************************************************************************
* Footnote 9: testing for order effects:

egen mpeffort=mean(peffort), by(subject)
egen mmae=mean(mae), by(subject)

ttest mpeffort if situation==1, by(revorder)
* p=0.61
ttest mmae if situation==1, by(revorder)
* p=0.70

* No difference in mean effort and mae choices due to order.

******************************************************************************************
* Results Secion. 

**********************************************************************************
* Section 4.1:

// Generate the percentage difference in every game for every individual:
gen IV_percent=IV/offeraccept

// Average percentage difference:
sum IV_percent
* The average difference is 16.7 percent.

// For the t-test, we average the certainty equivalents at the individual level:
egen mean_IV_percent=mean(IV_percent), by(subject)
ttest mean_IV_percent=0 if situation==1
* Percentage difference is different from zero at the p<0.001 level.

sum mean_IV_percent if situation==1
* Standard Deviation is 15.6 percent.

// We compute the individual average certainty equivalents for the control and delegation lotteries and test whether their difference is different from zero:

egen mean_oa=mean(offeraccept), by(subject)
egen mean_oad=mean(offeracceptd), by(subject)

gen mean_IV=mean_oad-mean_oa
// Signed-Rank Test whether average difference in certainty equivalents is equal to zero:
signrank mean_IV=0 if situation==1
* rejected at the p<0.001 level
dis 57/69
* 83% have a positive average value, 19% a negative average value.
dis 12/69
* 17% zero or negative value

* Test for difference in certainty equivalents for each individual game:
bysort situation: ttest IV_percent=0
bysort situation: signrank IV_percent=0
* Only in game 9, significance levels are > 0.01.


**********************************************************************************
* Do the expected values predict the certainty equivalents?
preserve
rename offeracceptd offeraccept2
rename offeraccept offeraccept1
rename EV_control EV1
rename EV_deleg EV2
reshape long offeraccept EV, i(subject situation) j(delsit)
pwcorr offeraccept EV, sig
* rho=0.89, p<0.001
restore

// Correlation between the difference in expected value and the CE difference:
pwcorr EV_diff IV, sig
* rho=0.58, p<0.001

**********************************************************************************

* Generate a percentage difference in EV for each game
gen ev_percent=EV_diff/EV_control
egen mean_ev_percent=mean(ev_percent), by(subject)

ttest mean_ev_percent=0 if situation==1
* The average difference is 7.1 percent.


* Test significance of the expected value differences:
* Calculate average expected value difference at the individual level, then test if average difference is equal to zero:
egen mean_EV_diff=mean(EV_diff), by(subject)
signrank mean_EV_diff=0 if situation==1

dis 57/69
// 82.6% have on average a positive EV Difference (p<0.001 signed rank test)

* Tests for each individual game:
bysort situation: signrank ev_percent=0
bysort situation: ttest ev_percent=0
* Significant in all games at the 5% level except game 9 (10 % level) and game 5 (not significant)




********************************************************************
*** Consistency of the Measure accross games (Cronbach Alpha): 

preserve
keep subject situation ev_percent IV_percent
reshape wide ev_percent IV_percent, i(subject) j(situation)
alpha  IV_percent1 IV_percent2 IV_percent3 IV_percent4 IV_percent5 IV_percent6 IV_percent7 IV_percent8 IV_percent9 IV_percent10
alpha  ev_percent1 ev_percent2 ev_percent3 ev_percent4 ev_percent5 ev_percent6 ev_percent7 ev_percent8 ev_percent9 ev_percent10
restore
* alpha= 0.62 for IV
* alpha= 0.77 for ev

*******************************************************************
* Section 4.2: Situational Determinants:

egen IV_stakemean=mean(IV), by(subject stakesize)
egen IV_conflictmean=mean(IV), by(subject conflict)
*paired t-tests:
preserve
replace conflict=50 if conflict==0.5
replace conflict=75 if conflict==0.75
replace conflict=100 if conflict==1

keep if situation==1 | situation==3 | situation==10
keep IV_stakemean IV_conflictmean subject conflict
reshape wide IV_stakemean IV_conflictmean, i(subject) j(conflict)

* Testing whether importance has an impact:
ttest IV_stakemean50=IV_stakemean100
* Difference: 18.9 points. p=0.0001
signrank IV_stakemean50=IV_stakemean100
dis 40/52
* 77% have higher WTPs in high importance. p-value signed rank test: 0.0001

ttest IV_conflictmean50=IV_conflictmean75
* Difference from 0.5 to 0.75: 11.1. p=0.02
signrank IV_conflictmean50=IV_conflictmean75 
dis 34/52
* 65% have higher WTP as alignment increases from 0.5 to 0.75. p-value signed rank test: 0.03

ttest IV_conflictmean50=IV_conflictmean100
* Difference from 0.5 to 0.75: 18.4 p=0.086
signrank IV_conflictmean50=IV_conflictmean100 
dis 31/52
* 60% have higher WTP as alignment increases from 0.5 to 1. p-value signed rank test: 0.081

ttest IV_conflictmean75=IV_conflictmean100
* Difference from 0.75 to 1: 7.3 p=0.51
signrank IV_conflictmean75=IV_conflictmean100 
dis 29/52
* 56% have higher WTP as alignment increases from 0.75 to 1. p-value signed rank test: 0.56

restore

**********************************************************************************
* Section 5: Alternative Explanations

**********************************************************************************
* 5.1 Loss Aversion:

* pwcorr mean_WTP_percent lossaversion if situation==1, sig
 pwcorr mean_IV lossaversion if situation==1, sig
* Correlation is rho=0.03. sig:0.81

/// Controlling for Consistency (footnote 29):

 pwcorr mean_IV lossaversion if situation==1 & consistent==1, sig
* Correlation is rho=0.065. sig: 0.6

**********************************************************************************
* 5.2 Illusion of Control:

tab ioc
* 91.5% have 0 willingness to pay to roll the dice.
 pwcorr mean_IV ioc if situation==1, sig
* Correlation is rho=-0.045. sig: 0.71

**********************************************************************************
*5.3 Preference Reversals:

gen pay_control_success=va-cost
gen pay_delegation_success=vc

count if pay_control_success>pay_delegation_success
dis 342/690
count if pay_control_success<pay_delegation_success
count if pay_control_success==pay_delegation_success
dis 6/690
* In 49.56% of the cases, the success payment at the control lottery is larger than at the delegation lottery.
* In 49.56% of the cases, the success payment at the control lottery is smaller than at the delegation lottery.
* In 0.87% of the cases, the payments are equal.


* Average success probabilities:

sum peffort mae
* 60% average success probability in control lotteries.
* 51% average success probability in delegation lotteries.

count if peffort>mae
count if peffort<mae
count if peffort==mae
dis 339/690 // 49.1% larger success probability at control lottery.
dis 272/690 // 39.4% larger success probability at delegation lottery.
dis 79/690 // 11.4	% equal success probabilities.

**********************************************************************************
* 5.4: Reciprocity

xtset subject
xi: xtreg IV_percent mae i.situation, cluster(subject) fe

* 5.5 Corner Solutions:

tab mae
* 15.8% of observations at mae==1.
* 1.9% of observations at mae==100.

* How often is mae==1 chosen by subject?
gen mae1=.
replace mae1=1 if mae==1
egen mae1count=count(mae1), by(subject)
tab mae1count if situation==1
* 51% never chose mae==1
* 77% chose mae==1 twice at most.

**********************
* Sign Test on how often a positive value and how often a negative value was assigned by each subject:

* Indicator for positive intrinsic value:
gen pos=.
replace pos=1 if IV>0 & mae!=1
* Number of assigned positive intrinsic values by subject:
egen poscount=count(pos), by(subject)

* Indicator for negative intrinsic value:
gen neg=.
replace neg=1 if IV<0
replace neg=1 if mae==1
* Number of assigned negative intrinsic values by subject:
egen negcount=count(neg), by(subject)

* Signtest whether number if positive and negative intrinsic value assignments are equal:
signtest poscount=negcount if situation==1
* 49 subjects assign a positive value more often.
* 14 assign a negative value more often
* 6 assign an equal number of positive and negative values.
* Sign Test is significant at the p>0.001 level.

*Recoding MAE==1 Corner Solutions as negative IV to conduct individual test for each game:
preserve
replace IV=-1 if mae==1
* Signtest for each game:
bysort situation: signtest IV=0
* Significant at p<0.05 for all games except 5 and 9.
restore

**********************************************************************************
* Evidence from additional control experiment:
clear
use Value.dta
tab mae if type==1 & maecontrol==1
*18.2 % mae==1 choices.

tab wtp_del_control if mae==1 & type==1 & maecontrol==1
* 30 out of 31 decided to keep decision rights in the control treatment and not to pay for delegation.
**********************************************************************************
* 5.5.2: Regressions on MAE and peffort:

reg mae maeopt if maecontrol==0, cluster(subject)
* coefficient is 0.74, p<0.01.

