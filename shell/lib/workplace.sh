# Truthy if this is a Target-managed device; falsy otherwise.
#
# Use this For Target-specific integrations.
function is_target_system() {
	type jamf >/dev/null 2>&1
}

# Truthy if this is an employer-managed device, falsy otherwise.
#
# Use this to opt-in or opt-out of configuration on any employer
# devices.
function is_employer_system() {
	is_target_system
}
