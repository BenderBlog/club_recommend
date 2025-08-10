<script lang="ts">
	import type { Snippet } from 'svelte';

	let {
		title,
		leadingbutton,
		iconbutton,
		bottom
	}: {
		title: Snippet | null;
		leadingbutton: Snippet | null;
		iconbutton: Snippet | null;
		bottom: Snippet | null;
	} = $props();
</script>

<header class="sticky top-0 z-10 bg-surface p-4">
	<div class="m3-font-title-large flex flex-row items-center justify-between text-on-surface">
		<div class="flex flex-row items-center space-x-1">
			{#if leadingbutton}
				<div class="mr-1">{@render leadingbutton?.()}</div>
			{/if}
			{@render title?.()}
		</div>

		{#if iconbutton}
			<div class="flex flex-col space-x-1">{@render iconbutton?.()}</div>
		{/if}
	</div>
	{#if bottom}
		<div class="overflow-hidden pt-4">
			{@render bottom?.()}
		</div>
	{/if}
</header>
