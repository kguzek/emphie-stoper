<script lang="ts">
	export let dimensions = 36;
	export let colour = 'none';
	export let name: string & keyof typeof svgs;

	const svgs: { [name: string]: string } = {
		timer: `<path fill="none" d="M0 0h24v24H0z" /><path d="M17.618 5.968l1.453-1.453 1.414 1.414-1.453 1.453a9 9 0 1 1-1.414-1.414zM12 20a7 7 0 1 0 0-14 7 7 0 0 0 0 14zM11 8h2v6h-2V8zM8 1h8v2H8V1z" fill="#808080" />`,
		cross: `<line x1="18" y1="6" x2="6" y2="18" /><line x1="6" y1="6" x2="18" y2="18" />`,
		trash: `<polyline points="3 6 5 6 21 6" /><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" /><line x1="10" y1="11" x2="10" y2="17" /><line x1="14" y1="11" x2="14" y2="17" />`
	};
</script>

<svg
	class={name}
	xmlns="http://www.w3.org/2000/svg"
	viewBox="0 0 24 24"
	width={dimensions}
	height={dimensions}
	fill="none"
	stroke={colour}
	stroke-width="2"
	stroke-linecap="round"
	stroke-linejoin="round"
>
	{@html svgs[name]}
</svg>
