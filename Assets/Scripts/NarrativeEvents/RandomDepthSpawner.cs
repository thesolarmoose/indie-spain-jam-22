using System;
using System.Collections;
using System.Collections.Generic;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Extensions;
using Random = UnityEngine.Random;

namespace NarrativeEvents
{
    public class RandomDepthSpawner : MonoBehaviour
    {
        [SerializeField] private List<Range> _depthRanges;
        [SerializeField] private FloatVariable _depthScale;
        [SerializeField] private GameObjectValueList _prefabsPool;
        [SerializeField] private float _minDelay;
        [SerializeField] private float _maxDelay;

        private List<GameObject> _alreadySpawned = new List<GameObject>();

        private void Start()
        {
            Spawn();
        }

        private void Spawn()
        {
            foreach (var range in _depthRanges)
            {
                var remaining = _prefabsPool.List.FindAll(prefab => !_alreadySpawned.Contains(prefab));
                var randomPrefab = remaining.GetRandom();
                var randomDepth = Random.Range(range.Min, range.Max) * _depthScale.Value;
                var position = new Vector3(0, -randomDepth, 0);
                var randomDelay = Random.Range(_minDelay, _maxDelay);
                _alreadySpawned.Add(randomPrefab);

                StartCoroutine(Spawn(randomPrefab, position, randomDelay));
            }
        }

        private IEnumerator Spawn(GameObject obj, Vector3 position, float delay)
        {
            yield return new WaitForSeconds(delay);
            Instantiate(obj, position, Quaternion.identity);
        }
    }
}