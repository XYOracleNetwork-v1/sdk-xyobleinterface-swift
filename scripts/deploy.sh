pod trunk register arie.trouw@xyo.network 'Xyo Team' --description='Deploy Script'
pod lib lint
pod --allow-warnings trunk push sdk-xyobleinterface-swift.podspec
