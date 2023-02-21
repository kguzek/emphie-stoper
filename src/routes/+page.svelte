<script lang="ts">
	import { browser } from '$app/environment';
	import { onMount } from 'svelte';
	import Button from '../components/Button.svelte';
	import Sidebar from '../components/Sidebar.svelte';
	import Statusbar from '../components/Statusbar.svelte';
	import type { Time } from '../models';
	import { formatTime } from '../util';

	let times: Time[] = [];
	let now = new Date();
	let startTime: number | undefined;
	let formattedTime = '00:00:00';
	let stopwatchMilliseconds = '000';

	// Read user's theme setting
	const userDarkMode = browser && localStorage.getItem('dark-mode');
	// Enable dark mode by default or if the user last used it
	let darkModeEnabled = userDarkMode !== 'false';

	/** Updates the clock and current stopwatch reading for this frame. */
	function tickTime() {
		now = new Date();
		if (startTime !== undefined) {
			const timeElapsed = now.getTime() - startTime;
			[formattedTime, stopwatchMilliseconds] = formatTime(timeElapsed);
		}
		// Calls this function recursively every frame.
		requestAnimationFrame(tickTime);
	}

	/** If the stopwatch is ticking, sets the start time to `undefined`. Otherwise, sets it to the current time. */
	function toggleStopwatch() {
		startTime = startTime === undefined ? new Date().getTime() : undefined;
	}

	/** If the stopwatch is currently ticking, adds the current time to the list of times. */
	function handleTime() {
		if (startTime === undefined) return;
		const newTime: Time = { primary: formattedTime, secondary: stopwatchMilliseconds };
		times = [...times, newTime];
	}

	onMount(() => {
		// Starts the frame tick loop.
		tickTime();
	});
</script>

<div class="root container {darkModeEnabled ? 'dark' : 'light'}">
	<main>
		<Sidebar {times} />
		<div class="stopwatch container">
			<div class="current-reading">
				<b>{formattedTime}</b>
				<small class={formattedTime + stopwatchMilliseconds === '00:00:00000' ? 'hidden' : ''}
					>{stopwatchMilliseconds}</small
				>
			</div>
			<div class="container-row">
				<Button
					className={startTime === undefined ? '' : 'red'}
					label={startTime === undefined ? 'Start' : 'Stop'}
					on:click={toggleStopwatch}
				/>
				<Button on:click={handleTime} disabled={startTime === undefined} label="Pomiar" />
			</div>
		</div>
		<Statusbar
			{now}
			{darkModeEnabled}
			toggleDarkMode={() => (darkModeEnabled = !darkModeEnabled)}
		/>
	</main>
</div>

<style lang="less">
	@import url('https://fonts.googleapis.com/css2?family=Poppins&family=Roboto+Mono:wght@700&display=swap');

	:global(body) {
		font-family: 'Bebas Neue', cursive;
		font-family: 'Poppins', sans-serif;
		margin: 0px;
	}

	:global(button) {
		border: none;
		background: none;
		cursor: pointer;
	}

	:global(.container) {
		display: flex;
		flex-direction: column;
		align-items: center;
	}

	.container-row {
		display: flex;
		flex-direction: row;
		justify-content: center;
		gap: 10px;
		width: 100%;
	}

	.stopwatch {
		width: 100%;
		height: 100%;
		justify-content: center;

		.current-reading {
			position: relative;
			font-size: xxx-large;
			color: var(--text-colour-accent);

			b {
				font-family: 'Roboto Mono', monospace;
			}

			small {
				position: absolute;
				margin-left: 0.5rem;
				bottom: 5px;

				&.hidden {
					visibility: hidden;
				}
			}
		}
	}

	.root {
		height: 100vh;
		justify-content: center;
		color: var(--text-colour-main);
		background-color: var(--background-colour-accent);

		&.light {
			--background-colour-main: #fff;
			--background-colour-accent: #eaeaea;
			--box-shadow-colour: #999;
			--text-colour-main: #808080;
			--text-colour-accent: #444;
			--text-colour-alt: #6b6b6b;
			--sidebar-colour-top: #c9d8e777;
			--sidebar-colour-bottom: #6c9fddaa;
			--disabled-colour: #bbb;
		}

		&.dark {
			--background-colour-main: #171717;
			--background-colour-accent: #333;
			--box-shadow-colour: #111;
			--text-colour-main: #808080;
			--text-colour-accent: #bbb;
			--text-colour-alt: #fff;
			--sidebar-colour-top: #33527eaa;
			--sidebar-colour-bottom: #0b0b0c77;
			--disabled-colour: #444;
		}
	}

	main {
		display: flex;
		position: relative;
		background-color: var(--background-colour-main);
		width: 70%;
		height: 100%;
		margin: 10vh;
		gap: 10px;
		border-radius: 15px;
		box-shadow: 0px 0px 50px var(--box-shadow-colour);
		overflow: hidden;
	}

	@media screen and (max-width: 600px) {
		.current-reading {
			font-size: calc(1rem + 5vw) !important;
			display: flex;
			justify-content: center;

			small {
				position: static !important;
				margin: 1vw 5px 0px !important;
				width: calc(1rem + 10vw) !important;
				visibility: visible !important;
			}
		}
	}

	@media screen and (max-width: 1000px) {
		main {
			width: 90%;
		}
	}
</style>
