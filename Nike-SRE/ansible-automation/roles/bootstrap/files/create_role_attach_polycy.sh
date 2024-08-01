for V in `cat /home/svi4808-a/automation/profiles_create_role.txt| cut -d '-' -f1` ; \
do \
echo '##############'Create Role in  $V ''##############'';\
    aws --profile=$V iam create-role --role-name BURoleForSREAutomation \
    --assume-role-policy-document file:///home/svi4808-a/automation/roles/aws/files/trust-policy.json  ;\
echo'' ;\
echo'' ;\
echo '##############'Create Policy in  $V ''##############'';\
    aws --profile=$V iam create-policy \
        --policy-name BUPolicyForSREAutomation \
	    --policy-document file:///home/svi4808-a/automation/roles/aws/files/BUPolicyForSREAutomation.json ;\


echo '##############'Attach Policy Role in  $V ''##############'';\
    aws --profile=$V iam attach-role-policy --policy-arn arn:aws:iam::`grep $V /home/svi4808-a/automation/profiles_create_role.txt| cut -d '-' -f2`:policy/BUPolicyForSREAutomation --role-name BURoleForSREAutomation ;\
echo '' ;\
echo '';\
 done


#aws iam delete-role-policy --role-name Test-Role --policy-name ExamplePolicy
#aws iam delete-role --role-name Test-Role
#aws iam delete-role --role-name Test-Role
#aws iam delete-policy --policy-arn arn:aws:iam::123456789012:policy/MySamplePolicy

