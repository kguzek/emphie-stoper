<script lang="ts">
	export let label: string;
	export let className: string = '';
	export let disabled: boolean = false;
</script>

<button on:click class="btn {className}" {disabled}>
	<b>{label}</b>
</button>

<style lang="less">
	.btn {
		font-weight: bold;
		color: white;
		padding: 10px;
		border-radius: 20px;
		background-color: #58f;
		width: 40%;
		min-width: 100px;
		max-width: 200px;
		text-transform: uppercase;

		&.red {
			background-color: #f55;
		}

		&.clear-times {
			width: 150px;
		}

		&:not(:active, [disabled]) {
			box-shadow: 0px 4px 8px var(--box-shadow-colour);
		}

		&[disabled] {
			cursor: not-allowed;
			background-color: var(--disabled-colour);
		}

		// &:active:not([disabled]) {
		// 	opacity: 0.8;
		// }
	}
</style>
