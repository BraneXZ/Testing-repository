#
# This script checks for open seats in Galaxy
#
# NOTE: USES EMPLOYEE PORTAL, NOT SURE IF SAME AS STUDENT
#

cd /home/pi/galaxy/

# Source the user information
. user_info

# FORMAT OF user_info
# USERID=netid
# PASS=password

# Set the Internal Field Separator to newline
IFS=$'\n' 

#
# Go download pages
#

# Post login information - if works, it should redirect to Galaxy main page
echo -n "Logging in... "
wget -q -O main_page.html --keep-session-cookies --save-cookies cookies.txt --post-data "userid=${USERID}&pwd=${PASS}" "https://sis-portal-prod.utdallas.edu/psp/DEPPRD/?cmd=login&languageCd=ENG"
echo "done!"

# Sleep to reduce suspicion 
#sleep 5

# Grab the page that hss the class list
echo -n "Grabbing shopping cart... "
wget -q -O class_list.html --load-cookies cookies.txt "https://sis-cs-prod.utdallas.edu/psc/DCSPRD/EMPLOYEE/SA/c/SA_LEARNER_SERVICES.SSR_SSENRL_CART.GBL?Page=SSR_SSENRL_CART&Action=A"
echo "done!"

# Sleep some more to reduce suspicion
#sleep 3

# Logout (not sure if necessary, but I want to play by the rules)
echo -n "Logging out... "
wget -q -O logout.html --load-cookies cookies.txt --keep-session-cookies --save-cookies cookies.txt "https://sis-portal-prod.utdallas.edu/psp/DEPPRD/EMPLOYEE/EMPL_UTD/?cmd=logout"
echo "done!"

echo "Checking for openings..."

#
# Process downloaded text
#

# Name of class
#grep "win0divP_CLASS_NAME" class_list.html | cut -d'>' -f4 | cut -d'<' -f1
# Name of professor
#grep "DERIVED_REGFRM1_SSR_INSTR_LONG" class_list.html | cut -d'>' -f3 | cut -d'<' -f1
# Hours
#grep SSR_REGFORM_VW_UNT_TAKEN class_list.html | cut -d'>' -f 3 | cut -d'<' -f1
# Open/Closed/Enrolled/Dropped
#grep "/cs/DCSPRD/cache/PS_CS_STATUS_" class_list.html | grep -v "win0div" | cut -d'"' -f8- | cut -d'"' -f1


# Make array with name of class
count=0
classes=()
profs=()
hours=()
statuses=()
course_ids=() #
for class in `grep "win0divP_CLASS_NAME" class_list.html | cut -d'>' -f4 | cut -d'<' -f1`; do 
	count=$(($count + 1))
	classes=(${classes[@]} $class)
	#echo ${classes[@]}
	#echo $count
done

for prof in `grep "DERIVED_REGFRM1_SSR_INSTR_LONG" class_list.html | cut -d'>' -f3 | cut -d'<' -f1`; do
	profs=(${profs[@]} "$prof")
done

for hour in `grep SSR_REGFORM_VW_UNT_TAKEN class_list.html | cut -d'>' -f 3 | cut -d'<' -f1`; do
	hours=(${hours[@]} $hour)
done

for status in `grep "/cs/DCSPRD/cache/PS_CS_STATUS_" class_list.html | grep -v "win0div" | cut -d'"' -f8- | cut -d'"' -f1`; do
	statuses=(${statuses[@]} $status)
done

for course_id in `grep "win0divP_CLASS_NAME" class_list.html | cut -d'(' -f3 | cut -d')' -f1`; do
	course_ids=(${course_ids[@]} $course_id)
done

declare -A data
num_rows=$count
num_columns=4

for ((i=0;i<num_rows;i++)) do
	data[$i,1]=${classes[i]}
	data[$i,2]=${profs[$i]}
	data[$i,3]=${hours[$i]}
	data[$i,4]=${statuses[$i]}
	data[$i,5]=${course_ids[i]}
	#echo "Class: ${data[$i,1]} Status: ${data[$i,4]} Professor: ${data[$i,2]} Hours: ${data[$i,3]}"
done

for ((i=0;i<num_rows;i++)) do
	echo "Class: ${data[$i,1]} Status: ${data[$i,4]} Professor: ${data[$i,2]} Hours: ${data[$i,3]}"
	
	# Check to see if class is open
	if [ "${data[$i,4]}" = "Open" ] ; then
		echo "OPENING! OPENING! OPENING!"
		string="ID: ${data[$i,5]} Class: ${data[$i,1]} Status: ${data[$i,4]} Professor: ${data[$i,2]} Hours: ${data[$i,3]}"
		./send_txt.py "$string"
		#echo "$string"
	fi
done