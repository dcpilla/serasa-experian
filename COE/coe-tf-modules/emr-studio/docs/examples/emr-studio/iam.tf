resource "aws_iam_role" "BURoleForEMR" {
  name = replace("BURoleForEMR${var.team}","_","")
  assume_role_policy = data.template_file.aws-emr-role-trust-policy.rendered
  permissions_boundary = data.aws_iam_policy.eec_boundary_policy.arn

  tags = local.default_tags
}
resource "aws_iam_role_policy" "BUPolicyForEMR" {
  name   = replace("BUPolicyForEMR${var.team}", "_", "")
  role   = aws_iam_role.BURoleForEMR.id
  policy = local.aws_emr_role_policy[var.env]

}
resource "aws_iam_instance_profile" "BURoleForEMRInstanceProfile" {
  name = aws_iam_role.BURoleForEMR.name
  role = aws_iam_role.BURoleForEMR.name
}
resource "aws_iam_role_policy_attachment" "ssm-fullaccess-role-policy-attach" {
  role       = "${aws_iam_role.BURoleForEMR.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}