provider "aws" {
  region = "sa-east-1"  
}
resource "aws_acmpca_certificate_authority" "private-serasa-ca" {
  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"

    subject {
    country             = "BR"     
    organization        = "Experian Serasa"
    organizational_unit = "Data Plataform"
    state               = "Sao Paulo"
    locality            = "Sao Paulo"
    
  }
  }
    type = "ROOT"
}
