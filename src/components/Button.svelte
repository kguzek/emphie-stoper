<script lang="ts">
	export let label: string;
	export let className: string = '';
	export let disabled: boolean = false;
</script>

<button on:click class={`btn ${className}`} {disabled}>
	<b>{label}</b>
</button>

<style lang="less">
	.btn {
		font-weight: bold;
		color: white;
		padding: 10px;
		border: none;
		border-radius: 20px;
		background-color: #58f;
		cursor: pointer;
		width: 40%;
		min-width: 100px;
		max-width: 200px;
		text-transform: uppercase;

		&.stop {
			background-color: #f55;
		}

		&[disabled] {
			cursor: not-allowed;
			background-color: #b0b0b0;
		}

		&:active:not([disabled]) {
			opacity: 0.8;
		}
	}
</style>
