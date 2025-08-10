<script lang="ts">
	import { Card } from 'm3-svelte';
	import { clubTypeName, type ClubInfo } from '$lib/model';

	export let data: ClubInfo;

	function goToCode() {
		window.location.href = '/detail/' + data.code;
	}
</script>

<Card variant="filled" onclick={goToCode}>
	<div class="flex flex-row items-center p-1">
		<div class="mr-3 h-16 w-16 flex-shrink-0">
			<img src={data.icon} alt={data.title} class="h-full w-full rounded-full object-cover" />
		</div>

		<div class="flex min-w-0 flex-1 flex-col justify-center">
			<div class="flex flex-row items-center justify-between gap-2">
				<h3 class="truncate text-base font-semibold">
					{data.title}
				</h3>

				<div class="flex flex-shrink-0 flex-row gap-1">
					{#each data.type as type}
						<span class="rounded-full bg-primary px-2 py-0.5 text-xs text-on-primary">
							{clubTypeName[type]}
						</span>
					{/each}
				</div>
			</div>

			<p class="mt-1 truncate text-sm text-on-surface-variant">
				{data.intro}
			</p>
		</div>
	</div>
</Card>
