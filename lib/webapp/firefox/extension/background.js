/*
browser.runtime.onMessage.addListener(async (msg) => {
  if (msg.action === "saveText") {
    let saved = await browser.storage.local.get("notes");
    let notes = saved.notes || [];
    notes.push({ text: msg.payload, time: Date.now() });
    await browser.storage.local.set({ notes });
    return { status: "ok" };
  }
});
*/

let port = browser.runtime.connectNative("ping_pong");

function logURL(requestDetails) {
  console.log(`Loading: ${requestDetails.url}`);
  port.postMessage("ping");
}

browser.webRequest.onBeforeRequest.addListener(logURL, {
  urls: ["<all_urls>"],
});


port.onMessage.addListener((response) => {
  console.log("Received: " + response);
});

port.onDisconnect.addListener((port) => {
  if (port.error) {
    console.log(`Disconnected due to an error: ${port.error.message}`);
  } else {
    // The port closed for an unspecified reason. If this occurred right after
    // calling `browser.runtime.connectNative()` there may have been a problem
    // starting the native messaging client in the first place.
    // https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging#troubleshooting
    console.log(`Disconnected`, port);
  }
});

browser.webNavigation.onBeforeNavigate.addListener((details) => {
  // Check if it's the main frame
  if (details.frameId === 0 && details.url.includes("donate")) {
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
