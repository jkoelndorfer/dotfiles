_google_cloud_sdk_dir="$HOME/google-cloud-sdk"
if [[ -d "$_google_cloud_sdk_dir" ]]; then
    pathmunge "$_google_cloud_sdk_dir/bin"
fi
unset _google_cloud_sdk_dir
