network=""
if [ ${2} ]
then
    network="--network ${2}"
fi
npx hardhat $network test test/work/${1}