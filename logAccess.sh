
#!/bin/sh

gcloud auth login --brief #Logging in Google Account

curacc=$(gcloud config get-value account)
var=$(date +"%d-%m-%Y_%T")
projects=$(gcloud projects list --format="value(projectId)")

currdate="${curacc}${var}"


check=`echo ${projects} | wc -w`

if [ $check == 0 ] 
then 
    echo "\nNo projects for this account\n"
    echo "Do you want to Logout from the gcloud session : "
    read conf

    if [ $conf == 'y' ]|| [ $conf == 'Y' ]
        then
        gcloud auth revoke ${curracc}   # logging out from current account
    fi

    echo "\nSCRIPT COMPLETED SUCCESSFULLY\n"
    exit 0
fi


mkdir ${currdate}_LOGS

cd ${currdate}_LOGS

echo "\nNo. of projects: "  
echo "$projects" | wc -l

echo "\nDisplaying List of all Projects\n"
i=1
for p in $projects:
    do
        echo "$i: ${p}"
        i=$((i+1))
    done

echo "\nFetching Logs for all Projects\n"
if [ ! -d AuditLogs ]  #Audit Logs Directory doesn't exist
then
    mkdir AuditLogs
fi
cd AuditLogs
for project in  $projects
    do  
        echo "\nDisplaying Logs at " $var "for" $project >> ${project}_ACTIVITY_AUDIT_LOGS.json
        echo "Fetching Audit logs from" $project "at" $var
        tempFile="tempLogFile"
        #command to store last 10 days audit logs 
        
       
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=json >> ${project}_ACTIVITY_AUDIT_LOGS.json  #store logs in temporary file
        


        if [ -s ${tempFile} ] #temporary file not empty
        then
            echo "Successfully downloaded activity logs"
        else
            echo "No activity logs returned"
            echo "No activity logs returned from" $project >> ${project}_ACTIVITY_AUDIT_LOGS.json
            rm $tempFile #delete temporary file
        fi
    done
cd ..



echo "\n\nFetching IAM Policies for all Projects\n"
if [ ! -d IAM_Policies ] #IAM Policies Directory doesn't exist
then
    mkdir IAM_Policies
fi
cd IAM_Policies   
for project in  $projects
    do
        echo "\nDisplaying IAM policies at " $var "for" $project >> ${project}_IAM_POLICY.json 
        echo "Fetching IAM policies from" $project "at" $var
        tempFile="tempPoliciesFile.txt" 
        #command to store all IAM policies
        gcloud projects get-iam-policy $project >> ${tempFile}
        if [ -s ${tempFile} ] #temporary file not empty
        then
            cat ${tempFile} >> ${project}_IAM_POLICY.json
            echo "Successfully downloaded IAM policies"
            rm $tempFile #delete temporary file
        else
            echo "No IAM policies returned"
            echo "No IAM policies returned from" $project >> ${project}_IAM_POLICY.json
            rm $tempFile #delete temporary file
        fi
    done
cd ..

echo "\n\nFetching Firewall Rules for all Projects\n"
if [ ! -d Firewall_Rules ] #Firewall Rules Directory doesn't exist
then
    mkdir Firewall_Rules
fi
cd Firewall_Rules   
for project in  $projects
    do
        echo "\nDisplaying Firewall Rules at " $var "for" $project >> ${project}_Firewall_Rules.json
        echo "Fetching Firewall Rules from" $project "at" $var
        tempFile="tempFirewallRulesFile.txt" 
        #command to store all Firewall Rules
        gcloud compute firewall-rules list --project=$project >> ${tempFile}
        if [ -s ${tempFile} ] #temporary file not empty
        then
            cat ${tempFile} >> ${project}_Firewall_Rules.json
            echo "Successfully downloaded Firewall Rules"
            rm $tempFile #delete temporary file
        else
            echo "No Firewall Rules returned"
            echo "No Firewall Rules returned from" $project >> ${project}_Firewall_Rules.json
            rm $tempFile #delete temporary file
        fi
    done
cd ..

echo "\n\nFetching list of Compute Engine Instances for all Projects\n"
if [ ! -d ComputeEngine_Instances ] #Directory doesn't exist
then
    mkdir ComputeEngine_Instances
fi
cd ComputeEngine_Instances   
for project in  $projects
    do
        echo "\nDisplaying list of Compute Engine Instances at " $var "for" $project >> ${project}_GCE_InstancesList.json
        echo "Fetching list of Compute Engine Instances from" $project "at" $var
        tempFile="tempGCEinstancesList.txt" 
        #command to store list of all Compute Engine Instances
        gcloud compute instances list --project=$project >> ${tempFile}
        if [ -s ${tempFile} ] #temporary file not empty
        then
            cat ${tempFile} >> ${project}_GCE_InstancesList.json
            echo "Successfully downloaded list"
            rm $tempFile #delete temporary file
        else
            echo "No list returned"
            echo "No list returned from" $project >> ${project}_GCE_InstancesList.json
            rm $tempFile #delete temporary file
        fi
    done
cd ..
cd ..

#Script to upload log file using Signed URL


zip -r ${currdate}_LOGS.zip ${currdate}_LOGS


url=$(curl -m 70 -o -X POST https://us-central1-crested-aquifer-352613.cloudfunctions.net/Signed_url \
-H "Content-Type:application/json" \
-d '{"name": "'"$currdate"'"}')

curl -X PUT -H 'Content-Type: application/octet-stream' --upload-file ${currdate}_LOGS.zip $url

echo "\nFile has been uploaded successfully\n"




# end of Script to upload log file using Signed URL


echo "Do you want to Logout from the gcloud session : "
read conf

if [ $conf == 'y' ]|| [ $conf == 'Y' ]


then
gcloud auth revoke ${curracc}   # logging out from current account
fi


echo "\nSCRIPT COMPLETED SUCCESSFULLY\n"
