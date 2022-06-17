import datetime

from google.cloud import storage
from google.cloud import error_reporting

def generate_upload_signed_url_v4(bucket_name, blob_name):
    
    print("entered in function")
    storage_client = storage.Client.from_service_account_json('private_key.json')
    bucket = storage_client.bucket(bucket_name,)
    print(bucket.name)
    blob = bucket.blob(blob_name)
    print(blob.name)
    client = error_reporting.Client()
    print("going in try block:")
    try:
        print(blob.bucket)
        url = blob.generate_signed_url(
            version="v4",
        # This URL is valid for 15 minutes
            expiration=datetime.timedelta(minutes=30),
        # Allow PUT requests using this URL.
            method="PUT",
            content_type="application/octet-stream",
        )
        print("After Generating URL")
    except Exception as e:
        print("Exception occured")
        print(e)

    print(bucket_name,blob_name)
    
    
    print("got all")
    print("Generated PUT signed URL:")
    print(url)
    print("You can use this URL with any user agent, for example:")
    print(
        "curl -X PUT -H 'Content-Type: application/octet-stream' "
        "--upload-file my-file '{}'".format(url)
    )
    return url


def hello_world(request):
    """Responds to any HTTP request.
    Args:
        request (flask.Request): HTTP request object.
    Returns:
        The response text or any set of values that can be turned into a
        Response object using
        `make_response <http://flask.pocoo.org/docs/1.0/api/#flask.Flask.make_response>`.
    """
    request_json = request.get_json()
    if request.args and 'name' in request.args:
        name= request.args.get('name')
    elif request_json and 'name' in request_json:
        name= request_json['name']
    else:
        name='new_file'
    url1=generate_upload_signed_url_v4("my-new-bucket22",name)
    print("Execution completed")
    return url1
