
#!/bin/sh
var=$(date +"%d-%m-%Y_%T")
projects=$(gcloud projects list --format="value(projectId)")

echo -n "\nNo. of projects: "  
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
        echo "\nDisplaying Logs at " $var "for" $project >> ${project}_ACTIVITY_AUDIT_LOGS.log  
        echo "Fetching logs from" $project "at" $var
        tempFile="tempLogFile"
        #command to store last 10 days audit logs 
        
        mkdir json
        cd json 
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=json >> ${tempFile}.json  #store logs in temporary file
        cd ..

        mkdir txt
        cd txt
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=text >> ${tempFile}.txt  #store logs in temporary file
        cd ..

        mkdir csv
        cd csv
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=csv >> ${tempFile}.csv  #store logs in temporary file
        cd ..

        mkdir diff
        cd diff
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=diff >> ${tempFile}.diff  #store logs in temporary file
        cd ..

        mkdir flattened
        cd flattened
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=flattened >> ${tempFile}.csv  #store logs in temporary file
        cd ..

        mkdir get
        cd get
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=get >> ${tempFile}.get  #store logs in temporary file
        cd ..

        mkdir list
        cd list
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=list >> ${tempFile}.txt  #store logs in temporary file
        cd ..

        mkdir object
        cd object
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=object >> ${tempFile}.object  #store logs in temporary file
        cd ..
        
        mkdir table
        cd table
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=table >> ${tempFile}  #store logs in temporary file
        cd ..

        mkdir value
        cd value
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=value >> ${tempFile}.csv  #store logs in temporary file
        cd ..

        mkdir yaml
        cd yaml
        gcloud logging read "logName : projects/$project/logs/cloudaudit.googleapis.com" \
            --project=$project --freshness="10D" --format=yaml >> ${tempFile}.yaml  #store logs in temporary file
        cd ..

        if [ -s ${tempFile} ] #temporary file not empty
        then
            echo "Successfully downloaded activity logs"
        else
            echo "No activity logs returned"
            echo "No activity logs returned from" $project >> ${project}_ACTIVITY_AUDIT_LOGS.log
            rm $tempFile #delete temporary file
        fi
    done
cd ..

# echo "\n\nFetching IAM Policies for all Projects\n"
# if [ ! -d IAM_Policies ] #IAM Policies Directory doesn't exist
# then
#     mkdir IAM_Policies
# fi
# cd IAM_Policies   
# for project in  $projects
#     do
#         echo "\nDisplaying IAM policies at " $var "for" $project >> ${project}_IAM_POLICY.yaml 
#         echo "Fetching IAM policies from" $project "at" $var
#         tempFile="tempPoliciesFile.txt" 
#         #command to store all IAM policies
#         gcloud projects get-iam-policy $project >> ${tempFile}
#         if [ -s ${tempFile} ] #temporary file not empty
#         then
#             cat ${tempFile} >> ${project}_IAM_POLICY.yaml
#             echo "Successfully downloaded IAM policies"
#             rm $tempFile #delete temporary file
#         else
#             echo "No IAM policies returned"
#             echo "No IAM policies returned from" $project >> ${project}_IAM_POLICY.yaml
#             rm $tempFile #delete temporary file
#         fi
#     done
# cd ..

# echo "\n\nFetching Firewall Rules for all Projects\n"
# if [ ! -d Firewall_Rules ] #Firewall Rules Directory doesn't exist
# then
#     mkdir Firewall_Rules
# fi
# cd Firewall_Rules   
# for project in  $projects
#     do
#         echo "\nDisplaying Firewall Rules at " $var "for" $project >> ${project}_Firewall_Rules.txt 
#         echo "Fetching Firewall Rules from" $project "at" $var
#         tempFile="tempFirewallRulesFile.txt" 
#         #command to store all Firewall Rules
#         gcloud compute firewall-rules list --project=$project >> ${tempFile}
#         if [ -s ${tempFile} ] #temporary file not empty
#         then
#             cat ${tempFile} >> ${project}_Firewall_Rules.txt
#             echo "Successfully downloaded Firewall Rules"
#             rm $tempFile #delete temporary file
#         else
#             echo "No Firewall Rules returned"
#             echo "No Firewall Rules returned from" $project >> ${project}_Firewall_Rules.txt
#             rm $tempFile #delete temporary file
#         fi
#     done
# cd ..

# echo "\n\nFetching list of Compute Engine Instances for all Projects\n"
# if [ ! -d ComputeEngine_Instances ] #Directory doesn't exist
# then
#     mkdir ComputeEngine_Instances
# fi
# cd ComputeEngine_Instances   
# for project in  $projects
#     do
#         echo "\nDisplaying list of Compute Engine Instances at " $var "for" $project >> ${project}_GCE_InstancesList.txt 
#         echo "Fetching list of Compute Engine Instances from" $project "at" $var
#         tempFile="tempGCEinstancesList.txt" 
#         #command to store list of all Compute Engine Instances
#         gcloud compute instances list --project=$project >> ${tempFile}
#         if [ -s ${tempFile} ] #temporary file not empty
#         then
#             cat ${tempFile} >> ${project}_GCE_InstancesList.txt
#             echo "Successfully downloaded list"
#             rm $tempFile #delete temporary file
#         else
#             echo "No list returned"
#             echo "No list returned from" $project >> ${project}_GCE_InstancesList.txt
#             rm $tempFile #delete temporary file
#         fi
#     done
# cd ..