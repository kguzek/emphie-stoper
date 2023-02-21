<script lang="ts">
	import Icon from './Icon.svelte';

	export let now: Date;
	$: currentTime = now.toLocaleTimeString([], {
		hour: '2-digit',
		minute: '2-digit',
		second: '2-digit'
	});
	export let darkModeEnabled: boolean;
	export let toggleDarkMode: () => void;
</script>

<div class="status-bar">
	<b class="clock">{currentTime}</b>
	<button
		class={darkModeEnabled ? 'dark' : 'light'}
		on:click={() => {
			toggleDarkMode();
			localStorage?.setItem('dark-mode', (!darkModeEnabled).toString());
		}}
	>
		<Icon name="sun" colour="#808080" dimensions={32} />
		<Icon name="moon" colour="#808080" dimensions={32} />
	</button>
</div>

<style lang="less">
	.status-bar {
		position: absolute;
		display: flex;
		align-items: center;
		top: 15px;
		right: 15px;

		.clock {
			width: 7ch;
		}

		button {
			position: relative;
			width: 40px;
			height: 32px;

			:global(> svg) {
				position: absolute;
				top: 0px;
				left: 5px;
				transition: opacity 500ms ease;
			}

			&.dark {
				:global(.sun) {
					opacity: 1;
				}

				:global(.moon) {
					opacity: 0;
				}
			}

			&.light {
				:global(.moon) {
					opacity: 1;
				}

				:global(.sun) {
					opacity: 0;
				}
			}
		}
	}
</style>
