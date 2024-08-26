resource "null_resource" "cleanning" { 
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      rm -rf ${data.archive_file.eks-scale-up.output_path} && \
      rm -rf ${data.archive_file.eks-scale-down.output_path} && \
      rm -rf ${data.archive_file.eks-scale-karpenter-down.output_path} && \
      rm -rf ${path.module}/${local_file.autoscale_up_lambda_rendered.filename} && \
      rm -rf ${path.module}/${local_file.autoscale_down_lambda_rendered.filename}
      rm -rf ${path.module}/${local_file.autoscale_karpenter_down_lambda_rendered.filename}
    EOT
  }

  depends_on = [aws_lambda_function.eks-scale-up, aws_lambda_function.eks-scale-down, aws_lambda_function.eks-scale-karpenter-down]
}
