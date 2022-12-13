<style lang="less">
	:global(body) {
		display: flex;
		justify-content: center;
		background-color: lightgrey;
		padding-top: 10px;
	}
	main {
		display: flex;
		flex-direction: column;
		align-items: center;
		background-color: white;
		border-radius: 15px;
		padding: 15px;
		min-width: 40%;
	}

	.btn {
		padding: 5px;
		border: 2px solid grey;
		border-radius: 10px;
		background-color: lightgrey;
		cursor: pointer;
		width: 100px;

		&.start {
			background-color: lightgreen;
		}

		&.stop {
			background-color: #ff9999;
		}

		&.disabled {
			cursor: not-allowed;
			background-color: #e5e5e5;
			border-color: #aaa;
			color: grey;
		}
	}
</style>
<script lang="ts">
	import { onMount } from "svelte";

	let formattedTime = "00:00:00";
  let stopwatchMillis = "000";
	let startTime;	
	let stopwatchStarted = false;

	const divMod = (dividend: number, divisor: number) => [Math.floor(dividend / divisor), dividend % divisor];

	function formatTime(millis: number) {
		let hours, minutes, seconds;
		[seconds, millis] = divMod(millis, 1000);
		[minutes, seconds] = divMod(seconds, 60);
		[hours, minutes] = divMod(minutes, 60);
		const parts = [hours, minutes, seconds].map((part) => `${part}`.padStart(2, "0"));
		formattedTime = parts.join(":");
		stopwatchMillis = `${millis}`.padStart(3, "0");
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
	}

	onMount(() => {
		tickTime();
	});
</script>
<main>
	<div class="stopwatch">
		{formattedTime}
		<small>{stopwatchMillis}</small>
	</div>
	<div class="buttons">
		<button on:click={toggleStopwatch} class={stopwatchStarted ? "btn stop" : "btn start"}>
			{stopwatchStarted ? "Stop" : "Start"}
		</button>
		<button on:click={handleTime} class={stopwatchStarted ? "btn" : "btn disabled"}>
			Pomiar
		</button>
	</div>
</main>

