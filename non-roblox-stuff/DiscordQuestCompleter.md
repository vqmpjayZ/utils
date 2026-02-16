## Complete Recent Discord Quest

> [!NOTE]
> This does not works in browser for quests which require you to play a game! Use the [desktop app](https://discord.com/download) to complete those.

How to use this script:
1. Accept a quest under the Quests tab
2. Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd> to open DevTools
3. Go to the `Console` tab
4. Paste the following code and hit enter:
<details>
	<summary>Click to expand</summary>
	
```js
delete window.$;
let wpRequire = webpackChunkdiscord_app.push([[Symbol()], {}, r => r]);
webpackChunkdiscord_app.pop();

function findExport(pred) {
	for (let id in wpRequire.c) {
		let mod = wpRequire.c[id];
		if (!mod?.exports) continue;
		for (let key in mod.exports) {
			try {
				if (mod.exports[key] && pred(mod.exports[key])) return mod.exports[key];
			} catch (e) {}
		}
	}
	return null;
}

let ApplicationStreamingStore = findExport(x => x?.__proto__?.getStreamerActiveStreamMetadata);
let RunningGameStore = findExport(x => x?.getRunningGames);
let QuestsStore = findExport(x => x?.__proto__?.getQuest);
let ChannelStore = findExport(x => x?.__proto__?.getAllThreadsForParent);
let GuildChannelStore = findExport(x => x?.getSFWDefaultChannel);
let FluxDispatcher = findExport(x => x?.__proto__?.flushWaitQueue);
let TokenStore = findExport(x => typeof x?.getToken === "function");

let token = TokenStore?.getToken();
if (!token) {
	console.log("Couldn't find your token!");
}

let api = {
	get: async ({ url }) => {
		let res = await fetch(`https://discord.com/api/v9${url}`, {
			headers: { Authorization: token },
		});
		return { body: await res.json() };
	},
	post: async ({ url, body }) => {
		let res = await fetch(`https://discord.com/api/v9${url}`, {
			method: "POST",
			headers: { Authorization: token, "Content-Type": "application/json" },
			body: JSON.stringify(body),
		});
		return { body: await res.json() };
	},
};

const supportedTasks = ["WATCH_VIDEO", "PLAY_ON_DESKTOP", "STREAM_ON_DESKTOP", "PLAY_ACTIVITY", "WATCH_VIDEO_ON_MOBILE"];
let isApp = typeof DiscordNative !== "undefined";

async function getQuests() {
	if (QuestsStore?.quests) {
		let quests = [...QuestsStore.quests.values()].filter(
			(x) =>
				x.userStatus?.enrolledAt &&
				!x.userStatus?.completedAt &&
				new Date(x.config.expiresAt).getTime() > Date.now() &&
				supportedTasks.find((y) => Object.keys((x.config.taskConfig ?? x.config.taskConfigV2).tasks).includes(y))
		);
		if (quests.length > 0) return quests;
	}

	console.log("QuestsStore failed or empty, trying API...");

	let res = await fetch("https://discord.com/api/v9/quests/@me", {
		headers: { Authorization: token },
	});
	let allQuests = await res.json();

	return allQuests.filter(
		(x) =>
			x.userStatus?.enrolledAt &&
			!x.userStatus?.completedAt &&
			new Date(x.config.expiresAt).getTime() > Date.now() &&
			supportedTasks.find((y) => Object.keys((x.config.taskConfig ?? x.config.taskConfigV2).tasks).includes(y))
	);
}

(async () => {
	let quests = await getQuests();

	if (quests.length === 0) {
		console.log("You don't have any uncompleted quests!");
		return;
	}

	console.log("Found quests:", quests.map((q) => q.config.messages.questName));

	let doJob = async function () {
		const quest = quests.pop();
		if (!quest) return;

		const pid = Math.floor(Math.random() * 30000) + 1000;
		const applicationId = quest.config.application.id;
		const applicationName = quest.config.application.name;
		const questName = quest.config.messages.questName;
		const taskConfig = quest.config.taskConfig ?? quest.config.taskConfigV2;
		const taskName = supportedTasks.find((x) => taskConfig.tasks[x] != null);
		const secondsNeeded = taskConfig.tasks[taskName].target;
		let secondsDone = quest.userStatus?.progress?.[taskName]?.value ?? 0;

		if (taskName === "WATCH_VIDEO" || taskName === "WATCH_VIDEO_ON_MOBILE") {
			const maxFuture = 10, speed = 7, interval = 1;
			const enrolledAt = new Date(quest.userStatus.enrolledAt).getTime();
			let completed = false;
			console.log(`Spoofing video for ${questName}.`);

			while (true) {
				const maxAllowed = Math.floor((Date.now() - enrolledAt) / 1000) + maxFuture;
				const diff = maxAllowed - secondsDone;
				const timestamp = secondsDone + speed;
				if (diff >= speed) {
					const res = await api.post({ url: `/quests/${quest.id}/video-progress`, body: { timestamp: Math.min(secondsNeeded, timestamp + Math.random()) } });
					completed = res.body.completed_at != null;
					secondsDone = Math.min(secondsNeeded, timestamp);
				}
				if (timestamp >= secondsNeeded) break;
				await new Promise((resolve) => setTimeout(resolve, interval * 1000));
			}
			if (!completed) {
				await api.post({ url: `/quests/${quest.id}/video-progress`, body: { timestamp: secondsNeeded } });
			}
			console.log("Quest completed!");
			doJob();

		} else if (taskName === "PLAY_ON_DESKTOP") {
			if (!isApp) {
				console.log("This needs the desktop app for", questName);
				doJob();
				return;
			}

			let res = await api.get({ url: `/applications/public?application_ids=${applicationId}` });
			const appData = res.body[0];
			const exeName = appData.executables.find((x) => x.os === "win32").name.replace(">", "");

			const fakeGame = {
				cmdLine: `C:\\Program Files\\${appData.name}\\${exeName}`,
				exeName,
				exePath: `c:/program files/${appData.name.toLowerCase()}/${exeName}`,
				hidden: false,
				isLauncher: false,
				id: applicationId,
				name: appData.name,
				pid: pid,
				pidPath: [pid],
				processName: appData.name,
				start: Date.now(),
			};

			let realGetRunningGames, realGetGameForPID;
			if (RunningGameStore && FluxDispatcher) {
				const realGames = RunningGameStore.getRunningGames();
				realGetRunningGames = RunningGameStore.getRunningGames;
				realGetGameForPID = RunningGameStore.getGameForPID;
				RunningGameStore.getRunningGames = () => [fakeGame];
				RunningGameStore.getGameForPID = (p) => [fakeGame].find((x) => x.pid === p);
				FluxDispatcher.dispatch({ type: "RUNNING_GAMES_CHANGE", removed: realGames, added: [fakeGame], games: [fakeGame] });
			}

			console.log(`Spoofed game to ${applicationName}. Sending heartbeats every 20s for ~${Math.ceil((secondsNeeded - secondsDone) / 60)} minutes.`);

			const channelId = ChannelStore?.getSortedPrivateChannels?.()?.[0]?.id ?? Object.values(GuildChannelStore?.getAllGuilds?.() ?? {}).find((x) => x != null && x.VOCAL?.length > 0)?.VOCAL[0]?.channel?.id ?? "0";
			const streamKey = `call:${channelId}:1`;

			while (true) {
				try {
					let hbRes = await api.post({ url: `/quests/${quest.id}/heartbeat`, body: { stream_key: streamKey, terminal: false } });
					let progress = hbRes.body?.progress?.[taskName]?.value ?? secondsDone;
					secondsDone = progress;
					console.log(`Quest progress: ${Math.floor(progress)}/${secondsNeeded}`);

					if (progress >= secondsNeeded) {
						await api.post({ url: `/quests/${quest.id}/heartbeat`, body: { stream_key: streamKey, terminal: true } });
						break;
					}
				} catch (e) {
					console.log("Heartbeat error:", e);
				}
				await new Promise((resolve) => setTimeout(resolve, 20 * 1000));
			}

			if (RunningGameStore && FluxDispatcher && realGetRunningGames) {
				RunningGameStore.getRunningGames = realGetRunningGames;
				RunningGameStore.getGameForPID = realGetGameForPID;
				FluxDispatcher.dispatch({ type: "RUNNING_GAMES_CHANGE", removed: [fakeGame], added: [], games: [] });
			}

			console.log("Quest completed!");
			doJob();

		} else if (taskName === "STREAM_ON_DESKTOP") {
			if (!isApp) {
				console.log("This needs the desktop app for", questName);
				doJob();
				return;
			}

			let realFunc;
			if (ApplicationStreamingStore) {
				realFunc = ApplicationStreamingStore.getStreamerActiveStreamMetadata;
				ApplicationStreamingStore.getStreamerActiveStreamMetadata = () => ({
					id: applicationId,
					pid,
					sourceName: null,
				});
			}

			const channelId = ChannelStore?.getSortedPrivateChannels?.()?.[0]?.id ?? Object.values(GuildChannelStore?.getAllGuilds?.() ?? {}).find((x) => x != null && x.VOCAL?.length > 0)?.VOCAL[0]?.channel?.id ?? "0";
			const streamKey = `call:${channelId}:1`;

			console.log(`Spoofed stream to ${applicationName}. Sending heartbeats every 20s for ~${Math.ceil((secondsNeeded - secondsDone) / 60)} minutes.`);
			console.log("Remember you need at least 1 other person in the vc!");

			while (true) {
				try {
					let hbRes = await api.post({ url: `/quests/${quest.id}/heartbeat`, body: { stream_key: streamKey, terminal: false } });
					let progress = hbRes.body?.progress?.[taskName]?.value ?? secondsDone;
					secondsDone = progress;
					console.log(`Quest progress: ${Math.floor(progress)}/${secondsNeeded}`);

					if (progress >= secondsNeeded) {
						await api.post({ url: `/quests/${quest.id}/heartbeat`, body: { stream_key: streamKey, terminal: true } });
						break;
					}
				} catch (e) {
					console.log("Heartbeat error:", e);
				}
				await new Promise((resolve) => setTimeout(resolve, 20 * 1000));
			}

			if (ApplicationStreamingStore && realFunc) {
				ApplicationStreamingStore.getStreamerActiveStreamMetadata = realFunc;
			}

			console.log("Quest completed!");
			doJob();

		} else if (taskName === "PLAY_ACTIVITY") {
			const channelId = ChannelStore?.getSortedPrivateChannels?.()?.[0]?.id ?? Object.values(GuildChannelStore?.getAllGuilds?.() ?? {}).find((x) => x != null && x.VOCAL?.length > 0)?.VOCAL[0]?.channel?.id ?? "0";
			const streamKey = `call:${channelId}:1`;

			console.log("Completing quest", questName);

			while (true) {
				const res = await api.post({ url: `/quests/${quest.id}/heartbeat`, body: { stream_key: streamKey, terminal: false } });
				const progress = res.body.progress.PLAY_ACTIVITY.value;
				console.log(`Quest progress: ${progress}/${secondsNeeded}`);

				await new Promise((resolve) => setTimeout(resolve, 20 * 1000));

				if (progress >= secondsNeeded) {
					await api.post({ url: `/quests/${quest.id}/heartbeat`, body: { stream_key: streamKey, terminal: true } });
					break;
				}
			}

			console.log("Quest completed!");
			doJob();
		}
	};
	doJob();
})();
```
</details>

# Videos may not be supported anymore
### (If you're unable to paste into the console, you might have to type `allow pasting` and hit enter)

5. Follow the printed instructions depending on what type of quest you have
    - If your quest says to "play" the game or watch a video, you can just wait and do nothing
    - If your quest says to "stream" the game, join a vc with a friend or alt and stream any window
7. Wait a bit for it to complete the quest
8. You can now claim the reward!

You can track the progress by looking at the `Quest progress:` prints in the Console tab, or by looking at the progress bar in the quests tab.

## FAQ

**Q: Running the script does nothing besides printing "undefined", and makes chat messages not go through**

A: This is a random bug with opening devtools, where all http requests break for a few minutes. It's not the script's fault. Either wait and try again, or restart discord and try again.

**Q: Can I get banned for using this?**

A: There is always a risk, though so far nobody has been banned for this or other similar things like client mods. (Very unlikely for a ban to happen)


**Q: Ctrl + Shift + I doesn't work**

A: Either download the [ptb client](https://discord.com/api/downloads/distributions/app/installers/latest?channel=ptb&platform=win&arch=x64), or use [this](https://www.reddit.com/r/discordapp/comments/sc61n3/comment/hu4fw5x/) to enable DevTools on stable.


**Q: Ctrl + Shift + I takes a screenshot**

A: Disable the keybind in your AMD Radeon app.


**Q: I get a syntax error/unexpected token error**

A: Make sure your browser isn't auto-translating this website before copying the script. Turn off any translator extensions and try again.


**Q: I'm on Vesktop but it tells me that I'm using a browser**

A: Vesktop is not a true desktop client, it's a fancy browser wrapper. Download the actual desktop app instead.


**Q: I get a different error**

A: Make sure you're copy/pasting the script correctly and that you've have done all the steps.


**Q: Can I complete expired quests with this?**

A: No, there is no way to do that.


**Q: Can you make the script auto accept the quest/reward?**

A: No. Both of those actions may show a captcha, so automating them is not a good idea. Just do the two clicks yourself.


**Q: Can you make this a Vencord plugin?**

A: No. The script sometimes requires immediate updates for Discord's changes, and Vencord's update cycle and code review would be too slow for that. There are some Vencord forks which have implemented this script or their own quest completers if you really want one.


**Q: Can you upload the standalone script to a repo and make this gist's code a one line fetch()?**

A: No. Doing that would put you at risk because I (or someone in my account) could change the underlying code to be malicious at any time, then forcepush it away later, and you'd never know.
