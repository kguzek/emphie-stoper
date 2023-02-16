<style lang="less">
	.btn {
		font-weight: bold;
		color: white;
		padding: 10px;
		border: none;
		border-radius: 20px;
			background-color: rgb(87, 140, 255);
		cursor: pointer;
		width: 150px;
		text-transform: uppercase;

		&.stop {
			background-color: #eb5858;
		}

		&[disabled] {
			cursor: not-allowed;
			background-color: grey;
		}
	}
</style>
<script lang="ts">
	export let label: string;
	export let className: string = "";
	export let disabled: boolean = false;
</script>
<button on:click class={`btn ${className}`} disabled={disabled}>
	<b>{label}</b>
</button>
