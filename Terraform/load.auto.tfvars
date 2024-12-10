// 네트워크 변수
vpc_cidr = "10.0.0.0/16"
subnet_cidrs = [
  "10.0.1.0/24",  // master-2a
  "10.0.2.0/24",  // master-2c
  "10.0.3.0/24",  // worker-2a
  "10.0.4.0/24",  // worker-2c
  "10.0.5.0/24",  // db-2a
  "10.0.6.0/24",  // db-2c
  "10.0.40.0/24", // load Bblancer-2a
  "10.0.50.0/24"  // load Bblancer-2c
]
subnet_names = [
  "Master",
  "Worker",
  "DB",
  "Load Balancer"
]
any_ip = "0.0.0.0/0"

instance_indexes = {
  master        = 0,
  worker        = 2,
  db            = 4,
  load_balancer = 6
}
