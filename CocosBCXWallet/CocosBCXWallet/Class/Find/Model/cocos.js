function _sendPeRequest(serialNumber,params,methodName){let userAgentVal=navigator.userAgent;if(userAgentVal.indexOf('Android')>-1||userAgentVal.indexOf('Adr')>-1){window.DappJsBridge.pushMessage(serialNumber,JSON.stringify(params),methodName)}else{window.webkit.messageHandlers.pushMessage.postMessage({'params':params,'serialNumber':serialNumber,'methodName':methodName})}}function serialNumberFn(){return'serialNumber'+(new Date().getTime()+parseInt(Math.random()*100000000000))}class ClientFunction{constructor(){}transferAsset(params){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,params,'transferAsset');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}callContractFunction(params){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,params,'callContractFunction');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}getAccountInfo(){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,'','getAccountInfo');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}decodeMemo(params){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,params,'decodeMemo');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}transferNHAsset(params){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,params,'transferNHAsset');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}updateCollateralForGas(params){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,params,'updateCollateralForGas');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}claimVestingBalance(params){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,params,'claimVestingBalance');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}publishVotes(params){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,params,'publishVotes');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}walletLanguage(){const serialNumber=serialNumberFn();_sendPeRequest(serialNumber,'','walletLanguage');console.log('----walletLanguage--111----');return new Promise((resolve,reject)=>{window.callbackResult=function(returnSerialNumber,result){console.log('----walletLanguage------', result);if(returnSerialNumber==serialNumber){resolve(JSON.parse(result))}}})}}const hookFunction=new ClientFunction();const checkForExtension=(resolve,tries=0)=>{if(tries>20)return;if(window.scatter.isExtension)return resolve(true);setTimeout(()=>checkForExtension(resolve,tries+1),100)};class Index{constructor(){this.isExtension=true}async isInstalled(){return new Promise(resolve=>{setTimeout(()=>{resolve(false)},3000);Promise.race([checkForExtension(resolve)])})}transferAsset(params){return new Promise((resolve,reject)=>{hookFunction.transferAsset(params).then((res)=>{resolve(res)})})}callContractFunction(params){return new Promise((resolve,reject)=>{hookFunction.callContractFunction(params).then((res)=>{resolve(res)})})}getAccountInfo(){return new Promise((resolve,reject)=>{hookFunction.getAccountInfo().then((res)=>{resolve(res)})})}decodeMemo(params){return new Promise((resolve,reject)=>{hookFunction.decodeMemo(params).then((res)=>{resolve(res)})})}transferNHAsset(params){return new Promise((resolve,reject)=>{hookFunction.transferNHAsset(params).then((res)=>{resolve(res)})})}initConnect(url,core_asset,faucet_url,chainId){var _configParams={ws_node_list:[{url:url,name:'CocosWallet'}],faucet_url:faucet_url,networks:[{core_asset:core_asset,chain_id:chainId}],auto_reconnect:true,worker:false,real_sub:true,check_cached_nodes_data:false};BcxWeb.bcx=new BCX(_configParams)}updateCollateralForGas(params){return new Promise((resolve,reject)=>{hookFunction.updateCollateralForGas(params).then((res)=>{resolve(res)})})}claimVestingBalance(params){return new Promise((resolve,reject)=>{hookFunction.claimVestingBalance(params).then((res)=>{resolve(res)})})}publishVotes(params){return new Promise((resolve,reject)=>{hookFunction.publishVotes(params).then((res)=>{resolve(res)})})}walletLanguage(params){return new Promise((resolve,reject)=>{hookFunction.walletLanguage().then((res)=>{resolve(res)})})}queryGas(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryGas(params).then((res)=>{resolve(res)})})}queryVotes(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryVotes(params).then((res)=>{resolve(res)})})}queryAccountAllBalances(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAccountAllBalances(params).then((res)=>{resolve(res)})})}queryAccountInfo(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAccountInfo(params).then((res)=>{resolve(res)})})}queryNHAssets(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryNHAssets(params).then((res)=>{resolve(res)})})}queryAccountNHAssetOrders(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAccountNHAssetOrders(params).then((res)=>{resolve(res)})})}queryNHAssetOrders(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryNHAssetOrders(params).then((res)=>{resolve(res)})})}queryAccountNHAssets(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAccountNHAssets(params).then((res)=>{resolve(res)})})}fillNHAssetOrder(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.fillNHAssetOrder(params).then((res)=>{resolve(res)})})}queryAccountBalances(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAccountBalances(params).then((res)=>{resolve(res)})})}queryAccountOperations(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAccountOperations(params).then((res)=>{resolve(res)})})}queryAsset(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAsset(params).then((res)=>{resolve(res)})})}getAccountProposals(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.getAccountProposals(params).then((res)=>{resolve(res)})})}queryNHCreator(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryNHCreator(params).then((res)=>{resolve(res)})})}lookupWorldViews(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.lookupWorldViews(params).then((res)=>{resolve(res)})})}queryBlock(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryBlock(params).then((res)=>{resolve(res)})})}queryTransaction(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryTransaction(params).then((res)=>{resolve(res)})})}queryVestingBalance(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryVestingBalance(params).then((res)=>{resolve(res)})})}queryDataByIds(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryDataByIds(params).then((res)=>{resolve(res)})})}queryContract(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryContract(params).then((res)=>{resolve(res)})})}queryAccountContractData(params){return new Promise((resolve,reject)=>{BcxWeb.bcx.queryAccountContractData(params).then((res)=>{resolve(res)})})}}function inject(){window.BcxWeb=new Index();BcxWeb.getAccountInfo().then(res=>{window.BcxWeb.account_name=res.account_name});console.log('Release-V 2.0.0');document.dispatchEvent(new CustomEvent('scatterLoaded'))}inject();";document.getElementsByTagName('head')[0].appendChild(script);
