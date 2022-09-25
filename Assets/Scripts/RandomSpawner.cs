using System;
using System.Collections;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Extensions;

public class RandomSpawner : MonoBehaviour
{
    [SerializeField] private Rect _bounds;
    [SerializeField] private FloatVariable _depthScale;
    [SerializeField] private int _count;
    [SerializeField] private GameObject _prefab;


    private IEnumerator Start()
    {
        for (int i = 0; i < _count; i++)
        {
            Spawn();
            yield return new WaitForSeconds(0.1f);
        }
    }

    private void Spawn()
    {
        var pos = _bounds.RandomPositionInside();
        pos.y *= -_depthScale.Value;
        Instantiate(_prefab, pos, Quaternion.identity);
    }

}