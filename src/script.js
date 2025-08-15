const form = document.getElementById("chatForm");
const promptInput = document.getElementById("prompt");
const chatLog = document.getElementById("chatLog");

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const userText = promptInput.value.trim();
  if (!userText) return;

  // ユーザーの入力を表示
  addMessage("👤", userText);
  promptInput.value = "";

  try {
    const res = await fetch("/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ prompt: userText }),
    });

    if (!res.ok) {
      throw new Error(`HTTP error! status: ${res.status}`);
    }

    const data = await res.json();
    addMessage("🤖", data.reply || "(応答なし)");
  } catch (err) {
    addMessage("⚠️", `エラー: ${err.message}`);
  }
});

function addMessage(sender, text) {
  const div = document.createElement("div");
  div.textContent = `${sender} ${text}`;
  chatLog.appendChild(div);
}
