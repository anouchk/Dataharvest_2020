library(data.table)

#set working directory
setwd('/Users/analutzky/Desktop/Dataharvest2020')

# read French file of 2018 students 
Table_French_students=fread('/Users/analutzky/Desktop/AEF_DSR/2020/2020_04_inscrits_univ_ambrine/inscrits_2018_univ.csv')

# showing it excel-like
View(Table_French_students)
# showing column names
colnames(Table_French_students)
# put them into a variable
var.names=colnames(Table_French_students)
### getting rid of space and special characters in columns names 
colnames(Table_French_students)=make.names(var.names)
# showing column names
colnames(Table_French_students)

######### ROWS : WE JUST WANT TOURS UNIVERSITY ################################
Table_Tours = Table_French_students[Etablissement=="Université de Tours",]

######### COLUMNS : WE JUST WANT THE NUMBER OF STUDENTS, THE DISCIPLIN AND GRADE ################################
# let's create a vector with the columns that we find interesting
MYVARS=c('Etablissement', 'CURSUS_LMD','Grande.discipline','Nombre.d.étudiants.inscrits..inscriptions.principales..hors.étudiants.inscrits.en.parallèle.en.CPGE')
Extract_Tours = Table_Tours[,mget(MYVARS)]
#rename 4th column
colnames(Extract_Tours)[4]="Nb.students"

####### GROUPING BY : HOW MANY STUDENTS PER GRADE AND DISCIPLIN #######
Nb_students = Extract_Tours[,.(Students=sum(Nb.students)),by=.(CURSUS_LMD,Grande.discipline)]

######## RESHAPING #######
Nb_students = dcast(Nb_students,
				CURSUS_LMD~Grande.discipline,
				value.var=c("Students"))

# csv2 is for French csv (; as separator, and "," for decimals)
write.csv2(as.data.frame(Nb_students),file='Nb_students.csv',fileEncoding = "UTF8")
