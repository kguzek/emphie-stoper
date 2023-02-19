<script lang="ts">
	import { onMount } from 'svelte';
	import Button from '../components/Button.svelte';
	import Icon from '../components/Icon.svelte';
	import BtnTrash from '../components/BtnTrash.svelte';

	let formattedTime = '00:00:00';
	let stopwatchMilliseconds = '000';
	let currentTime = '';
	let startTime: number;
	let stopwatchStarted = false;
	let sidebarElement: Element;

	let times: { primary: string; secondary: string }[] = [
		// {
		// 	primary: '12:34:56',
		// 	secondary: '789'
		// }
	];

	const divMod = (dividend: number, divisor: number) => [
		Math.floor(dividend / divisor),
		dividend % divisor
	];

	function formatTime(milliseconds: number) {
		let hours, minutes, seconds;
		[seconds, milliseconds] = divMod(milliseconds, 1000);
		[minutes, seconds] = divMod(seconds, 60);
		[hours, minutes] = divMod(minutes, 60);
		const parts = [hours, minutes, seconds].map((part) => `${part}`.padStart(2, '0'));
		formattedTime = parts.join(':');
		stopwatchMilliseconds = `${milliseconds}`.padStart(3, '0');
	}

	function tickTime() {
		const now = new Date();
		currentTime = now.toLocaleTimeString([], {
			hour: '2-digit',
			minute: '2-digit',
			second: '2-digit'
		});
		if (stopwatchStarted) {
			const timeElapsed = now.getTime() - startTime;
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

	function toggleSidebar() {
		if (sidebarElement.classList.contains('hidden')) {
			sidebarElement.classList.remove('hidden');
		} else {
			sidebarElement.classList.add('hidden');
		}
	}

	function handleTime() {
		if (!stopwatchStarted) return;
		const newTime = { primary: formattedTime, secondary: stopwatchMilliseconds };
		times = [...times, newTime];
	}

	const deleteTime = (idxToDelete: number) =>
		(times = times.filter((_, idx) => idx !== idxToDelete));

	onMount(() => {
		tickTime();
	});
</script>

<div class="root container">
	<main>
		<aside class="container hidden" bind:this={sidebarElement}>
			<button on:click={toggleSidebar} class="btn-toggle-sidebar">
				<Icon name="timer" />
				<Icon name="cross" />
			</button>
			<h3>Zapisane czasy</h3>
			<ol>
				{#each times as time, idx}
					<li class="time">
						<div>
							<b>{time.primary}</b>
							<small>{time.secondary}</small>
						</div>
						<BtnTrash on:click={() => deleteTime(idx)} />
					</li>
				{/each}
			</ol>
		</aside>
		<div class="stopwatch container">
			<div class="current-reading">
				<b>{formattedTime}</b>
				{#if formattedTime + stopwatchMilliseconds !== '00:00:00000'}
					<small>{stopwatchMilliseconds}</small>
				{/if}
			</div>
			<div class="buttons container">
				<Button
					on:click={toggleStopwatch}
					className={stopwatchStarted ? 'stop' : 'start'}
					label={stopwatchStarted ? 'Stop' : 'Start'}
				/>
				<Button on:click={handleTime} disabled={!stopwatchStarted} label="Pomiar" />
			</div>
		</div>
		<b class="clock">{currentTime}</b>
	</main>
</div>

<style lang="less">
	@import url('https://fonts.googleapis.com/css2?family=Poppins&family=Roboto+Mono:wght@700&display=swap');

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
		width: 100%;
		height: 100%;
		justify-content: center;

		.current-reading {
			position: relative;
			font-size: xxx-large;

			b {
				font-family: 'Roboto Mono', monospace;
			}

			small {
				position: absolute;
				margin-left: 0.5rem;
				bottom: 2px;
			}
		}

		.buttons {
			flex-direction: row;
			justify-content: center;
			gap: 10px;
			width: 100%;
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
		position: relative;
		background-color: white;
		width: 70%;
		height: 100%;
		margin: 10vh;
		gap: 10px;
		border-radius: 15px;
		box-shadow: 0px 0px 50px lightgrey;
		overflow: hidden;
	}

	aside {
		position: relative;
		min-width: 300px;
		height: 100%;
		border-top-left-radius: 15px;
		border-bottom-left-radius: 15px;
		color: #808080;
		background-color: #d5e5f5;
		box-shadow: 0px 0px 100px grey;
		transition: all 500ms;
		z-index: 1;

		.btn-toggle-sidebar {
			all: unset;
			position: relative;
			left: 100px;
			top: 12px;
			cursor: pointer;
			transition: all 500ms;

			:global(.cross) {
				opacity: 1;
			}

			:global(.timer) {
				opacity: 0;
			}
		}

		&.hidden {
			margin-left: -300px;
			box-shadow: none;

			.btn-toggle-sidebar {
				margin-left: 115px;

				:global(.cross) {
					opacity: 0;
				}

				:global(.timer) {
					opacity: 1;
				}
			}
		}

		h3 {
			margin: 15px;
		}

		ol {
			display: flex;
			flex-direction: column;
			gap: 5px;
			padding: 0px 25px;
			margin: 0px;
			width: calc(100% - 2 * 25px);
			height: 100%;
			list-style-position: inside;
			overflow-y: auto;
		}
	}

	.time {
		position: relative;
		background-color: white;
		padding: 5px 10px;
		border-radius: 5px;

		div {
			position: absolute;
			height: 100%;
			top: 0px;
			left: 30px;
			display: flex;
			align-items: center;
			gap: 5px;
		}
	}

	.clock {
		position: absolute;
		top: 15px;
		right: 20px;
		width: 4rem;
	}

	@media screen and (max-width: 600px) {
		.clock {
			visibility: hidden;
		}

		.current-reading small {
			visibility: hidden;
		}
	}

	@media screen and (max-width: 1000px) {
		main {
			width: 90%;
		}
		aside {
			position: absolute;
			min-width: 225px;

			.btn-toggle-sidebar {
				left: 75px;

				:global(.cross) {
					scale: 85%;
				}
			}

			&.hidden {
				margin-left: -225px;

				.btn-toggle-sidebar {
					margin-left: 90px;
				}
			}
		}
	}
</style>
