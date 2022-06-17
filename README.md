# LogsAccessor_GCP
: Project to fetch Audit logs in various formats (text, json, csv), IAM policies, Firewall rules and Compute engine instances list from GCP for multiple projects.

: Post fetching the logs , they will be stored in a ZIP file and uploaded to GCP Bucket via Signed URL. (Bucket name : my-new-bucket22 to store the log zip file )

:Cloud Function / Signed_url.py is the cloud function for creating signed URL and sending it back in logAccess.sh .

:Cloud Function / private_key.json is the authentication key for service account.
