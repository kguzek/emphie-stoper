<style lang="less">
	:global(body) {
		display: flex;
		justify-content: center;
		background-color: lightgrey;
		padding-top: 10px;
	}
	.container {
		display: flex;
		flex-direction: column;
		align-items: center;
		padding: 15px;
		background-color: white;
	}
	aside {
		position: absolute;
		top: 0px;
		left: 0px;
		min-width: 200px;
		border-bottom-right-radius: 15px;

		h3 {
			margin: 10px;
		}
	}
	main {
		min-width: 40%;
		border-radius: 15px;
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

		&[disabled] {
			cursor: not-allowed;
			background-color: #e5e5e5;
			border-color: #aaa;
			color: grey;
		}
	}
	.time {
		button {
			align-text: center;
			border: none;
			margin-left: 0.5rem;
		}
	}
</style>
<script lang="ts">
	import { onMount } from "svelte";

	let formattedTime = "00:00:00";
  let stopwatchMilliseconds = "000";
	let startTime: number;
	let stopwatchStarted = false;

	let times: string[] = [];

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
<aside class="container">
	<h3>Pomiary</h3>
	{#each times as time, idx}
		<div class="time">
			{time.primary}
			<small>{time.secondary}</small>
			<button on:click={() => deleteTime(idx)}>x</button>
		</div>
	{/each}
	{#if times.length === 0}
		<i>Brak pomiarów</i>
	{/if}
</aside>
<main class="container">
	<div class="stopwatch">
		{formattedTime}
		<small>{stopwatchMilliseconds}</small>
	</div>
	<div class="buttons">
		<button on:click={toggleStopwatch} class={stopwatchStarted ? "btn stop" : "btn start"}>
			{stopwatchStarted ? "Stop" : "Start"}
		</button>
		<button on:click={handleTime} class="btn" disabled={!stopwatchStarted}>
			Pomiar
		</button>
	</div>
</main>

