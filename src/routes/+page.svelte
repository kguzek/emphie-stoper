<style lang="less">
	@import url('https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Poppins:wght@300&display=swap');

	:global(body) {
		background-color: #eaeaea;
		font-family: 'Bebas Neue', cursive;
		font-family: 'Poppins', sans-serif;
		color: #444;
	}
	.container {
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	.stopwatch {
		justify-content: center;
		height: 100%;
		min-width: 500px;

		div {
			width: 400px;
		}
		
		.current-reading {
			font-size: xxx-large;
			margin-left: 6rem;
		}

		.buttons {
			flex-direction: row;
			justify-content: center;
			gap: 10px;
		}
	}
	
	aside {
		margin: -15px -20px;
		min-width: 250px;
		border-top-left-radius: 15px;
		border-bottom-left-radius: 15px;
		color: grey;

		&.visible {
			background-color: rgb(213, 228, 248);
		}

		h3 {
			margin: 10px;
		}

		ol {
			display: flex;
			flex-direction: column;
			gap: 5px;
			padding: 0px;
			width: 80%;
			list-style-position: inside;

			.time {
				background-color: white;
				padding: 5px 10px;
				border-radius: 5px;

				b {
					margin-left: 10px;
				}
				
				button {
					border: none;
					float: right;
					background-color: transparent;
					color: red;
					cursor: pointer;
					display: flex;
					height: 100%;
					align-items: center;
				}
			}
		}
	}

	.root {
		position: absolute;
		top: 0px;
		left: 0px;
		height: 100vh;
		width: 100vw;
		justify-content: center;
	}
	
	main {
		display: flex;
		justify-content: space-between;
		background-color: white;
		width: 70%;
		height: 70%;
		gap: 10px;
		padding: 15px 20px;
		border-radius: 15px;
		box-shadow: 0px 0px 5px lightgrey;
	}
</style>
<script lang="ts">
	import { onMount } from "svelte";
	import Button from "../components/Button.svelte"

	let formattedTime = "00:00:00";
  let stopwatchMilliseconds = "000";
	let startTime: number;
	let stopwatchStarted = false;

	let times: {primary: string; secondary: string}[] = [
		{
			primary: "12:34:56",
			secondary: "789",
		},
	];

	const divMod = (dividend: number, divisor: number) => [Math.floor(dividend / divisor), dividend % divisor];

	function formatTime(milliseconds: number) {
		let hours, minutes, seconds;
		[seconds, milliseconds] = divMod(milliseconds, 1000);
		[minutes, seconds] = divMod(seconds, 60);
		[hours, minutes] = divMod(minutes, 60);
		const parts = [hours, minutes, seconds].map((part) => `${part}`.padStart(2, "0"));
		formattedTime = parts.join(":");
		stopwatchMilliseconds = `${milliseconds}`.padStart(3, "0");
	}

	function tickTime() {
		if (stopwatchStarted) {
			const timeElapsed = new Date().getTime() - startTime;
			formatTime(timeElapsed);
		}
		requestAnimationFrame(tickTime);
	}

	function toggleStopwatch() {
		stopwatchStarted = !stopwatchStarted;
		if (stopwatchStarted) {
			startTime = new Date().getTime();
		}
	}

	function handleTime() {
		if (!stopwatchStarted) return;
		const newTime = { primary: formattedTime, secondary: stopwatchMilliseconds };
		times = [...times, newTime];
	}

	const deleteTime = (idxToDelete: number) => times = times.filter((_, idx) => idx !== idxToDelete);

	onMount(() => {
		tickTime();
	});
</script>
<div class="root container">

	<main>
		<aside class={"container" + (times.length > 0 ? " visible" : "")}>
			<h3>{times.length > 0 ? "Zapisane czasy" : ""}</h3>
			<ol>
				{#each times as time, idx}
				<li class="time">
						<b>{time.primary}</b>
						<small>{time.secondary}</small>
					<button on:click={() => deleteTime(idx)}>X</button>
				</li>
				{/each}
			</ol>
		</aside>
		<div class="stopwatch container">
			<div>
				<div class="current-reading">
					<b>{formattedTime}</b>
					<small>{stopwatchMilliseconds}</small>
				</div>
				<div class="buttons container">
					<Button
					on:click={toggleStopwatch}
					className={stopwatchStarted ? "stop" : "start"}
					label={stopwatchStarted ? "Stop" : "Start"}
					/>
					<Button on:click={handleTime} disabled={!stopwatchStarted} label="Pomiar" />
				</div>
			</div>
		</div>
		<div class="clock">
			<b>{new Date().toLocaleTimeString([], {hour: "2-digit", minute: "2-digit", second: "2-digit"})}</b>
		</div>
	</main>
</div>

