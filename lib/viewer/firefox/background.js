let port = browser.runtime.connectNative("remoteviewer_server");

port.onMessage.addListener(function (response) {
  console.log("received: " + response);
  let u = response;

  chrome.tabs.update({url:u}).then(function() {
    console.log('done');
  });

  /*
  chrome.tabs.query({ active: true }, function (tabs) {
    var activeTab = tabs[0];
    var activeTabId = activeTab.id; // or do whatever you need…
  });
  */
});

port.onDisconnect.addListener(function (port) {
  if (port.error) {
    console.log(`disconnected due to an error: ${port.error.message}`);
  } 
  else {
    console.log(`disconnected ${port}`);
  }
});

/*
function logURL(requestDetails) {
  console.log(`loading: ${requestDetails.url}`);
  port.postMessage("loading:"+requestDetails.url);
}

browser.webRequest.onBeforeRequest.addListener(logURL, {
  urls: ["<all_urls>"]
});

browser.webNavigation.onBeforeNavigate.addListener(function (details) {
  if (details.frameId === 0 && details.url.includes("test")) {
     browser.scripting.executeScript({
       target: {
         tabId: details.tabId
       },
       func: function() {
         window.stop();
       }
     });
  }
});
*/
