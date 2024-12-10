terraform {
  backend "s3" {
    bucket  = "load-test-tfstate"
    key     = "terraform.tfstate"
    region  = "ap-northeast-2" # 원하는 리전으로 변경
    profile = "load"

    # DynamoDB 테이블을 사용하지 않으므로 잠금 비활성화
    dynamodb_table              = null
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
