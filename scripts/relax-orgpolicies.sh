#!/bin/bash

# Relax Org Policies that are too restrictive
# Note: Organization Policy Administrator IAM permissions are needed to run this script
# References:
# - https://cloud.google.com/sdk/gcloud/reference/beta/resource-manager
# - https://cloud.google.com/compute/docs/images/restricting-image-access#trusted_images
#
# USAGE: relax-orgpolicies.sh [PROJECT_ID]
# if no project is given, the current gcloud project is used
 
PROJECT=${1:-`gcloud config get-value project`}

declare -a policies=(
    "constraints/compute.vmExternalIpAccess"
    # "constraints/compute.disableNestedVirtualization"
    # "constraints/compute.disableSerialPortAccess"
    # "constraints/compute.disableVpcExternalIpv6"
    # "constraints/compute.requireOsLogin"
    # "constraints/compute.requireShieldedVm"
    # "constraints/compute.restrictSharedVpcHostProjects"
    # "constraints/compute.restrictSharedVpcSubnetworks"
    # "constraints/compute.restrictVpcPeering"
    # "constraints/compute.restrictVpnPeerIPs"
    # "constraints/compute.skipDefaultNetworkCreation"
    # "constraints/compute.storageResourceUseRestrictions"
    # "constraints/compute.trustedImageProjects"
    # "constraints/compute.vmCanIpForward"
    # "constraints/essentialcontacts.allowedContactDomains"
    # "constraints/iam.allowedPolicyMemberDomains"
    # "constraints/iam.disableServiceAccountCreation"
    # "constraints/iam.disableServiceAccountKeyCreation"
    # "constraints/iam.serviceAccountKeyExpiryHours"
    # "constraints/iam.serviceAccountKeyExposureResponse"
    # "constraints/resourcemanager.allowedExportDestinations"
)

for policy in "${policies[@]}"
do
    gcloud org-policies reset $policy --project=$PROJECT
done

