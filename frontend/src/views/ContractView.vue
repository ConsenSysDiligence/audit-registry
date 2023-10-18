<template>
  <div>
    <div class="justify-center mx-auto mt-32 w-1/2">
      <div class="p-6 bg-white shadow-md rounded-lg">
        <h1 class="text-xl font-bold mb-2">
          Audits for contract
          <p class="font-mono inline text-gray-500 font-extralight text-sm">
            {{ contractAddress }}
          </p>
          <br />with codehash
          <p class="font-mono inline text-gray-500 font-extralight text-sm">
            {{ codehash }}
          </p>
        </h1>
        <div v-if="true" class="flex items-center text-green-500">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
            class="h-6 w-6 mr-2"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M5 13l4 4L19 7"
            ></path>
          </svg>

          <p>
            There is at least one valid audit for the current version of this
            contract.
          </p>
        </div>

        <div v-else class="flex items-center text-red-500">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="red"
            class="h-6 w-6 mr-2"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M6 18L18 6M6 6l12 12"
            ></path>
          </svg>
          <p>No valid audit found for the current version of this contract.</p>
        </div>
      </div>
    </div>
    <div class="flex h-full justify-center mx-auto pt-8">
      <div class="w-1/3 pr-4 h-full">
        <h2 class="text-center text-3xl font-extrabold text-gray-900 mb-8">
          Audits
        </h2>
        <div class="overflow-scroll h-full">
          <div
            v-for="audit in audits"
            :key="audit.id"
            @click="selectedAudit = audit"
            class="bg-white shadow overflow-hidden sm:rounded-lg mb-4 cursor-pointer"
          >
            <div class="px-4 py-5 sm:px-6">
              <div class="flex justify-between">
                <h3 class="text-lg leading-6 font-medium text-gray-900 flex">
                  {{ audit.name }}
                </h3>
                <span
                  :class="
                    audit.isValid
                      ? 'bg-green-200 text-green-800'
                      : 'bg-red-200 text-red-800'
                  "
                  class="px-2 py-1 font-semibold leading-tight text-sm rounded-full"
                >
                  {{ audit.isValid ? 'OK' : 'NOK' }}
                </span>
              </div>
              <p class="mt-1 max-w-2xl text-sm text-gray-600">
                {{ audit.company }}
              </p>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                {{ audit.date }}
              </p>
              <p class="mt-1 max-w-2xl text-sm text-gray-500">
                Codehash:
                <span class="font-mono font-extralight">{{
                  audit.contractHash
                }}</span>
              </p>
            </div>
          </div>
        </div>
      </div>
      <div
        class="w-1/2 pl-4 h-full sticky top-20 self-start"
        v-if="selectedAudit"
      >
        <h2 class="text-center text-3xl font-extrabold text-gray-900 mb-8">
          Audit Details
        </h2>
        <div class="bg-white shadow overflow-hidden sm:rounded-lg">
          <div class="px-4 py-5 sm:px-6">
            <h3 class="text-lg leading-6 font-medium text-gray-900">
              {{ selectedAudit.name }}
            </h3>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">
              Audit Company: {{ selectedAudit.company }}
            </p>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">
              Date: {{ selectedAudit.date }}
            </p>
            <p class="mt-1 max-w-2xl text-sm text-gray-500">
              Contract Hash: {{ selectedAudit.contractHash }}
            </p>
            <div class="mt-1 max-w-2xl text-sm text-gray-500">
              <p>Associated Addresses:</p>

              <ul class="list-disc list-inside">
                <li
                  v-for="address in selectedAudit.associatedAddresses"
                  :key="address"
                  class="hover:text-indigo-600 cursor-pointer"
                >
                  {{ address }}
                </li>
              </ul>
            </div>

            <div class="mt-2">
              <a
                :href="selectedAudit.link"
                class="text-indigo-600 hover:text-indigo-900"
                target="_blank"
                >View Audit</a
              >
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { REGISTRY_ADDRESS } from '@/constants';
import { store } from "@/store";
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const selectedAudit = ref();
const contractAddress = ref();
const codehash = ref('0x73472647374279843283879');

onMounted(() => {
  contractAddress.value = route.params.address;
  fetchAuditStatus(contractAddress.value);
});

const fetchAuditStatus = function(address) {
    console.log(store.publicClients);
    // use MM provider to call artifacts view for target
    // parse result and give it format as below
    // set audits.value
}

const audits = ref([
  // Replace this with your actual data
  {
    id: 1,
    name: 'Audit 1',
    link: 'https://example.com/audit-1',
    company: 'Company 1',
    date: '2022-01-01',
    contractHash: '0x123',
    associatedAddresses: ['0x123', '0x456'],
    isValid: true,
  },
  {
    id: 2,
    name: 'Audit 2',
    link: 'https://example.com/audit-2',
    company: 'Company 2',
    date: '2022-01-02',
    contractHash: '0x123',
    associatedAddresses: ['0x124', '0x455'],
    isValid: false,
  },
  {
    id: 1,
    name: 'Audit 3',
    link: 'https://example.com/audit-3',
    company: 'Company 3',
    date: '2022-01-03',
    contractHash: '0x125',
    associatedAddresses: ['0x12', '0x456'],
    isValid: true,
  },
  {
    id: 1,
    name: 'Audit 3',
    link: 'https://example.com/audit-3',
    company: 'Company 3',
    date: '2022-01-03',
    contractHash: '0x125',
    associatedAddresses: ['0x12', '0x456'],
    isValid: true,
  },
  {
    id: 1,
    name: 'Audit 3',
    link: 'https://example.com/audit-3',
    company: 'Company 3',
    date: '2022-01-03',
    contractHash: '0x125',
    associatedAddresses: ['0x12', '0x456'],
    isValid: true,
  },
  {
    id: 1,
    name: 'Audit 3',
    link: 'https://example.com/audit-3',
    company: 'Company 3',
    date: '2022-01-03',
    contractHash: '0x125',
    associatedAddresses: ['0x12', '0x456'],
    isValid: true,
  },
  {
    id: 1,
    name: 'Audit 3',
    link: 'https://example.com/audit-3',
    company: 'Company 3',
    date: '2022-01-03',
    contractHash: '0x125',
    associatedAddresses: ['0x12', '0x456'],
    isValid: true,
  },
  {
    id: 1,
    name: 'Audit 3',
    link: 'https://example.com/audit-3',
    company: 'Company 3',
    date: '2022-01-03',
    contractHash: '0x125',
    associatedAddresses: ['0x12', '0x456'],
    isValid: true,
  },
  {
    id: 1,
    name: 'Audit 3',
    link: 'https://example.com/audit-3',
    company: 'Company 3',
    date: '2022-01-03',
    contractHash: '0x125',
    associatedAddresses: ['0x12', '0x456'],
    isValid: true,
  },
]);
</script>
