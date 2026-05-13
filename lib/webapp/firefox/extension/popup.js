document.getElementById("saveBtn").onclick = async () => {
  let tabs = await browser.tabs.query({ active: true, currentWindow: true });
  await browser.scripting.executeScript({ target: { tabId: tabs[0].id }, files: ["content.js"] });
};

(async () => {
  let stored = await browser.storage.local.get("notes");
  let notes = stored.notes || [];
  let list = document.getElementById("list");
  notes.forEach(n => {
    let li = document.createElement("li");
    li.textContent = n.text;
    list.appendChild(li);
  });
})();
