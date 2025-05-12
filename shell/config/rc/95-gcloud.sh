export GCLOUD_SDK_PATH="${HOME}/.local/share/google-cloud-sdk"

for cfg in completion path; do
	fp="${GCLOUD_SDK_PATH}/${cfg}.${SHELL_NAME}.inc"
	if [[ -f "$fp" ]]; then
		source "$fp"
	fi
done
