<script lang="ts">
	import { Button, Icon, LoadingIndicator } from 'm3-svelte';
	import iconCode from '@ktibow/iconset-material-symbols/code';

	import { ClubType, clubTypeName } from '$lib/model';
	import ReloadWidget from '$lib/components/ReloadWidget.svelte';
	import { getClubList } from '$lib/api';
	import ClubCard from '$lib/components/ClubCard.svelte';
	import AppBar from '$lib/components/AppBar.svelte';
	import Footer from '$lib/components/Footer.svelte';

	import type { PageProps } from './$types';

	let { data }: PageProps = $props();

	let shownType: ClubType = $state(ClubType.All);
	let clubListPromise = $state(data.clubListPromise);

	function reloadData(type: ClubType | null) {
		if (type != null) {
			shownType = type;
		}
		clubListPromise = getClubList(shownType);
	}

	const filterableTypes = Object.values(ClubType).filter(
		(t) => t !== ClubType.Unknown && t !== ClubType.All
	);
</script>

{#snippet type_button(type: ClubType)}
	<Button variant={shownType === type ? 'filled' : 'outlined'} onclick={() => reloadData(type)}>
		{clubTypeName[type]}
	</Button>
{/snippet}

{#snippet title()}
	<div>西电社团推荐</div>
{/snippet}

{#snippet icon_button()}
	<Button
		variant="text"
		iconType="full"
		onclick={() => window.open('https://github.com/BenderBlog/club_recommend')}
	>
		<Icon icon={iconCode}></Icon>
	</Button>
{/snippet}

{#snippet bottom()}
	<div class="flex flex-row text-nowrap">
		{@render type_button(ClubType.All)}
		<div class="mx-3 w-px bg-outline-variant"></div>
		<div class="flex flex-row gap-2 space-x-2 overflow-x-auto">
			{#each filterableTypes as type}
				{@render type_button(type)}
			{/each}
		</div>
	</div>
{/snippet}

<div class="flex min-h-screen flex-col">
	<AppBar {title} {bottom} iconbutton={icon_button} leadingbutton={null}></AppBar>
	<div class="flex-grow p-2">
		{#await clubListPromise}
			<div class="center-content">
				<LoadingIndicator></LoadingIndicator>
			</div>
		{:then result}
			{#if result.isOk()}
				{@const clubs = result.value}
				{#if clubs.length > 0}
					<div class="grid grid-cols-[repeat(auto-fill,minmax(280px,1fr))] gap-4 px-4">
						{#each clubs as club}
							<ClubCard data={club} />
						{/each}
					</div>
				{:else}
					<div class="items-center">
						<p>没有找到该分类下的社团。</p>
					</div>
				{/if}
			{:else}
				<ReloadWidget
					message={`获取数据函数执行中发生错误：${result.error.message}`}
					onReload={() => reloadData(null)}
				/>
			{/if}
		{:catch error}
			<ReloadWidget
				message={`获取数据过程中发生错误：${error.message}`}
				onReload={() => reloadData(null)}
			/>
		{/await}
	</div>

	<Footer></Footer>
</div>
