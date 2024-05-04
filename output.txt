
output "server-ipprivate" {
  value =aws_instance.serverpriv.private_ip
} 

output "server-ippublic" {
  value =aws_instance.serverpub.private_ip
} 

output "server-ippublic2" {
  value =aws_instance.serverpub.public_ip
} 
