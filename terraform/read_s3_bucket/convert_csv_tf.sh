#! /usr/bin/env bash

# with a file name called foo.csv and contents
#    one,1
#    two,2
#    three,3
# this script will generate a .tf file that contains
# a 'servers' variable that will look like this
#
#    variable "servers" {
#      default = {
#        "1-one" : "one",
#        "1-two" : "two",
#        "2-two" : "two",
#        "1-three" : "three",
#        "2-yarra" : "three",
#        "3-yarra" : "three",
#      }
#    }
# which will allow you to create servers in terraform with the same name, for example
# 
#  resource "aws_instance" "web" {
#    for_each = toset(keys(var.servers))
#    ami           = "${data.aws_ami.ubuntu.id}"
#    instance_type = "t2.micro"
#
#    tags = {
#      Name = var.servers[each.key]
#    }
#}

IFS=$'\n\t'

if [[ ! -f $1 ]]; then
    echo "Error, file $1 does not exist"
    exit 1
fi

OUT="${1%.*}"
cat << EOF > $OUT.tf
variable "servers" {
    default = {
EOF

for server in $(< $OUT.csv); do
    name=$(echo $server | cut -d ',' -f1)
    count=$(echo $server | cut -d ',' -f2)
    yes $name | head -n$count | cat -n | awk '{print "\""$1"-"$2"\":\"" $2"\","}'
done >> $OUT.tf

cat << EOF >> $OUT.tf
}
}
EOF

terraform fmt $OUT.tf

exit 0