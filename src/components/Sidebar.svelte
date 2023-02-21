<script lang="ts">
	import type { Time } from '../models';
	import Button from './Button.svelte';
	import Icon from './Icon.svelte';

	let sidebarElement: Element;
	export let times: Time[];

	function toggleSidebar() {
		if (sidebarElement.classList.contains('hidden')) {
			sidebarElement.classList.remove('hidden');
		} else {
			sidebarElement.classList.add('hidden');
		}
	}
</script>

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
		<Button
			label="Usuń wszystkie"
			className="red clear-times"
			on:click={() => (times.length = 0)}
		/>
	{/if}
	<ol>
		{#each times as time, itemIndex}
			<li class="time">
				<b>{time.primary}</b>
				<small>{time.secondary}</small>
				<button
					class="btn-delete"
					on:click={() => (times = times.filter((_, timeIndex) => timeIndex !== itemIndex))}
				>
					<Icon name="trash" dimensions={18} colour="#f55" />
				</button>
			</li>
		{/each}
	</ol>
</aside>

<style lang="less">
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

			:global(> svg) {
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

	@media screen and (max-width: 1000px) {
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
