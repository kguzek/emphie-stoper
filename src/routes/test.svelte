<script lang="ts">
	import { onMount } from 'svelte';
	import Button from '../components/Button.svelte';
	import Icon from '../components/Icon.svelte';

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
				<Icon name="cross" colour="#f55" />
				{#if times.length > 0}
					<b>{times.length}</b>
				{/if}
			</button>
			<h3>Zapisane czasy</h3>
			{#if times.length > 0}
				<Button label="Usuń wszystkie" className="red clear-times" on:click={() => (times = [])} />
			{/if}
			<ol>
				{#each times as time, idx}
					<li class="time">
						<b>{time.primary}</b>
						<small>{time.secondary}</small>
						<button class="btn-delete" on:click={() => deleteTime(idx)}>
							<Icon name="trash" dimensions={18} colour="#f55" />
						</button>
					</li>
				{/each}
			</ol>
		</aside>
		<div class="stopwatch container">
			<div class="current-reading">
				<b>{formattedTime}</b>
				<small class={formattedTime + stopwatchMilliseconds === '00:00:00000' ? 'hidden' : ''}
					>{stopwatchMilliseconds}</small
				>
			</div>
			<div class="container-row">
				<Button
					className={stopwatchStarted ? 'red' : ''}
					label={stopwatchStarted ? 'Stop' : 'Start'}
					on:click={toggleStopwatch}
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
		margin: 0px;
	}
	.container {
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
		border-radius: 15px;
		// background-color: #d5e5f5;
		background: linear-gradient(135deg, #d0e0f0aa, #d5e5f577);
		backdrop-filter: blur(10px);
		-webkit-backdrop-filter: blur(10px);
		box-shadow: 0px 8px 32px grey;
		transition: all 500ms;
		z-index: 1;
		gap: 15px;

		.btn-toggle-sidebar {
			all: unset;
			position: relative;
			left: 100px;
			top: 12px;
			cursor: pointer;
			transition: all 500ms;

			b {
				opacity: 0;
				top: 6px;
				left: 2.5rem;
			}

			:global(> *) {
				position: absolute;
				transition: opacity 500ms;
			}

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

				b {
					font-size: large;
					opacity: 1;
					color: #808080;
				}

				:global(.cross) {
					opacity: 0;
				}

				:global(.timer) {
					opacity: 1;
				}
			}
		}

		h3 {
			color: #6b6b6b;
			margin: 0px;
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
		display: flex;
		align-items: center;
		gap: 5px;
		color: #808080;
		background-color: white;
		padding: 5px 10px;
		border-radius: 5px;
		counter-increment: times 1;
		box-shadow: 0px 4px 8px grey;

		&::before {
			content: counter(times) '. ';
			min-width: 1rem;
			counter-reset: 1;
		}

		.btn-delete {
			margin-left: auto;
			border: none;
			background-color: transparent;
			cursor: pointer;
		}
	}

	.clock {
		position: absolute;
		top: 15px;
		right: 20px;
		width: 4rem;
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
		aside {
			position: absolute;
			min-width: 240px;

			.btn-toggle-sidebar {
				left: 80px;

				:global(.cross) {
					scale: 85%;
				}
			}

			&.hidden {
				margin-left: -240px;

				.btn-toggle-sidebar {
					margin-left: 100px;
				}
			}
		}
	}
</style>
