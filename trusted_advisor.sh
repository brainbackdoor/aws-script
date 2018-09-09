#!/bin/bash

./sh/trusted_advisor_instance.sh
./sh/trusted_advisor_ebs.sh
./sh/trusted_advisor_eip.sh
./sh/trusted_advisor_sg.sh
./sh/trusted_advisor_s3.sh

echo "# done."
